import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../data/repositories/category_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/ping_repository.dart';
import '../../data/sse.dart';
import '../../domain/data_models/answer/answer.dart';
import '../../domain/data_models/answer_type.dart';
import '../../domain/data_models/category/category.dart';
import '../../domain/data_models/chat.dart';
import '../../domain/data_models/question/question.dart';
import '../../domain/data_models/stream_message_response_status.dart';
import '../constants/chat_user.dart';
import '../utilities/chat_page_util.dart';

/// ViewModelへのグローバルアクセスを提供するProvider
final chatViewModel = ChangeNotifierProvider(
  (context) => ChatViewModel(),
);

/// ViewModel
class ChatViewModel with ChangeNotifier {
  ChatViewModel() {
    /// 初期化時に実行したい処理
    _getCategoriesAndUpdate();
  }

  final _errorController = StreamController<Exception>.broadcast();

  Stream<Exception> get errorStream => _errorController.stream;

  final _pingRepository = PingRepository();
  final _categoryRepository = CategoryRepository();
  final _chatRepository = ChatRepository();

  List<types.TextMessage> messages = [];
  bool isShowLoadingForStream = false;
  List<Category> categories = [
    Category(
      id: 1,
      name: 'Loading...',
      personName: 'Loading...',
      personImageUrl: '',
      backgroundImageUrl: '',
      introductionText: 'Loading...',
    ),
  ];
  int selectedCategoryIndex = 0;

  /// MARK: - 画面更新を発火する必要がない変数群（変更があった場合は、State内の変数の変更による再描画時に参照されて画面に反映される）
  ChatThread? currentChatThread = ChatThread(
    id: 0,
    messages: [],
    sourceUrlProvidedMessages: [],
  );
  StreamMessageResponseStatus messageStatus =
      StreamMessageResponseStatus.isFirst;
  StreamMessageResponseStatus actionInfoMessageStatus =
      StreamMessageResponseStatus.isFirst;
  StreamMessageResponseStatus webContentsScrapingProgressMessageStatus =
      StreamMessageResponseStatus.isFirst;
  List<String> waitingStrings = [];

  // 1回の回答のためにGoogle検索が任意の回数実行される可能性があるため、最後に送られてきたソースURLリストだけを採用するために、2次元配列にしている
  List<List<String>> twoDimensionSourceURLList = [];
  bool isURLString = false;
  Sse? _connection;
  StreamController _answerResponseController = StreamController();
  StreamSubscription<dynamic>? _answerResponseSubscription;

  /// MARK: - Viewの初期化タイミングに合わせて行う処理
  void onViewInitState() async {
    onSideMenuItemSelected(0);

    // サーバーAPIとの疎通確認
    _checkServerConnection();

    // このStreamはSingle subscription streamsである必要があるので、複数のlisterを持つとエラーになる
    // 万が一のケースで別のlistenerが解放されていないなどの場合には再度初期化する
    if (_answerResponseController.hasListener) {
      _answerResponseController = StreamController();
    }
    _answerResponseSubscription =
        _answerResponseController.stream.listen((value) async {
      _handleStreamAnswerResponseValue(value);
    });
  }

  /// 解放時に実行したい処理
  @override
  void dispose() {
    super.dispose();
    _errorController.close();
    _answerResponseController.close();
    _answerResponseSubscription?.cancel();
  }

  void onTapSendButton(String text) {
    final textMessage = types.TextMessage(
      author: ChatUser.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: ChatPageUtil.randomString(),
      text: text,
    );

    // 自分の入力メッセージをスレッドに表示
    _addMessage(textMessage);

    // 入力内容をAIに送信
    _sendQuestion(textMessage.text);
  }

  void onSideMenuItemSelected(int index) {
    selectedCategoryIndex = index;
    notifyListeners();

    _resetChatPageData();
    final introductionMessage = types.TextMessage(
      author: ChatUser.chatBot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: ChatPageUtil.randomString(),
      text: categories[selectedCategoryIndex].introductionText,
    );
    _addMessage(introductionMessage);
  }

  /// Private Methods
  void _checkServerConnection() async {
    try {
      final response = await _pingRepository.checkServerConnection();
      print('_checkServerConnection: ${response?.data.message ?? ''}');
    } on Exception catch (exception) {
      _errorController.add(exception);
    }
  }

  void _getCategoriesAndUpdate() async {
    try {
      var categories = await _categoryRepository.getCategories();
      print('categories: $categories');
      if (categories != null) {
        this.categories = categories;
        notifyListeners();
      }
    } on Exception catch (exception) {
      _errorController.add(exception);
    }
  }

  void _handleStreamAnswerResponseValue(dynamic value) {
    // print('_handleStreamAnswerResponseValue: $value');

    // TODO: DONEじゃなくて、answerTypeID=3とかで終了の合図にして、もっとスマートに書きたい
    if (value == 'DONE') {
      messageStatus = StreamMessageResponseStatus.isLast;
      isShowLoadingForStream = false;
      notifyListeners();

      if (twoDimensionSourceURLList.isNotEmpty) {
        currentChatThread?.sourceUrlProvidedMessages += [
          SourceUrlProvidedMessage(
              message: messages[0],
              sourceUrlList: twoDimensionSourceURLList.last)
        ];
      }
      _addStreamMessage(value);
    } else {
      // jsonをパースしてクラスに変換する
      final Map<String, dynamic> responseJson = json.decode(value);
      final StreamAnswerResponseData streamAnswerResponse =
          StreamAnswerResponseData.fromJson(responseJson);
      // レスポンスの種別を判別
      final AnswerType answerType =
          getAnswerTypeFromId(streamAnswerResponse.answerTypeId);

      // レスポンスの種別ごとに処理
      switch (answerType) {
        // FunctionCalling発動時のアクション内容を取り出して表示
        case AnswerType.actionInfo:
          final actionPrefixText =
              (streamAnswerResponse.actionInfo?.actionPrefix != null)
                  ? '${streamAnswerResponse.actionInfo?.actionPrefix}\n'
                  : '';
          // もしactionPrefixがあったらisFirstとして扱い、なかったらisWritingにする
          actionInfoMessageStatus = (actionPrefixText.isNotEmpty)
              ? StreamMessageResponseStatus.isFirst
              : StreamMessageResponseStatus.isWriting;
          final text =
              '$actionPrefixText${streamAnswerResponse.actionInfo?.partOfActionInputText ?? ''}';
          _addStreamActionInfoMessage(text);
          break;

        // 外部データ検索が行われた場合のソースURLを取り出して表示
        case AnswerType.sourceUrlList:
          twoDimensionSourceURLList += [
            streamAnswerResponse.sourceUrlList ?? []
          ];
          break;

        // 最終的な回答の断片を表示
        case AnswerType.partOfFinalAnswerText:
          final text = streamAnswerResponse.partOfFinalAnswerText;
          _addStreamMessage(text ?? '');
          break;

        // アクション情報の出力の完了通知
        case AnswerType.actionInputGenerationCompleted:
          // actionInfoMessageStatusをisLastに変更して空文字の追加で表示を更新し、終了する
          actionInfoMessageStatus = StreamMessageResponseStatus.isLast;
          _addStreamActionInfoMessage('');
          break;

        // 外部データ検索結果のスクレイピングなどの重い処理の進捗を割合表示するための値
        case AnswerType.webContentsScrapingProgress:
          _addStreamWebContentsScrapingProgressMessage(
              streamAnswerResponse.webContentsScrapingProgress ?? 0);
          break;
      }
    }
  }

  Future<void> _addMessage(types.TextMessage message) async {
    List<types.TextMessage> _messages = [];
    _messages.addAll(messages);
    _messages.insert(0, message);
    messages = _messages;
    notifyListeners();
    currentChatThread?.messages += [message];
  }

  Future<void> _addStreamMessage(String str, [bool saveToDB = true]) async {
    if (messageStatus == StreamMessageResponseStatus.isFirst) {
      messageStatus = StreamMessageResponseStatus.isWriting;
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages.insert(
          0,
          types.TextMessage(
            author: ChatUser.chatBot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: ChatPageUtil.randomString(),
            text: str,
          ));
      messages = _messages;
      notifyListeners();
    } else if (messageStatus == StreamMessageResponseStatus.isLast) {
      isShowLoadingForStream = false;
      notifyListeners();
      currentChatThread?.messages += [messages[0]];
    } else {
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages[0] = types.TextMessage(
        author: messages[0].author,
        createdAt: messages[0].createdAt,
        id: messages[0].id,
        text: messages[0].text + str,
      );
      messages = _messages;
      notifyListeners();
    }
  }

  Future<void> _addStreamActionInfoMessage(String str) async {
    if (actionInfoMessageStatus == StreamMessageResponseStatus.isFirst) {
      actionInfoMessageStatus = StreamMessageResponseStatus.isWriting;
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages.insert(
          0,
          types.TextMessage(
            author: ChatUser.actionInfo,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: ChatPageUtil.randomString(),
            text: str,
          ));
      messages = _messages;
      notifyListeners();
    } else if (actionInfoMessageStatus == StreamMessageResponseStatus.isLast) {
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages[0] = types.TextMessage(
        author: messages[0].author,
        createdAt: messages[0].createdAt,
        id: messages[0].id,
        text: messages[0].text + str,
        // 吹き出しWidget側でインジケータからチェックマークアイコンに表示変えをする為にメタデータとして受け渡す
        metadata: {'progress': 100},
      );
      messages = _messages;
      notifyListeners();
    } else {
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages[0] = types.TextMessage(
        author: messages[0].author,
        createdAt: messages[0].createdAt,
        id: messages[0].id,
        text: messages[0].text + str,
      );
      messages = _messages;
      notifyListeners();
    }
  }

  Future<void> _addStreamWebContentsScrapingProgressMessage(
      int progress) async {
    if (webContentsScrapingProgressMessageStatus ==
        StreamMessageResponseStatus.isFirst) {
      webContentsScrapingProgressMessageStatus =
          StreamMessageResponseStatus.isWriting;
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages.insert(
          0,
          types.TextMessage(
            author: ChatUser.actionInfo,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: ChatPageUtil.randomString(),
            text: '検索結果を解析しています… $progress%完了',
            // 吹き出しWidget側で進捗のインジケータ制御に使うのでメタデータとして渡す
            metadata: {'progress': progress},
          ));
      messages = _messages;
      notifyListeners();
    } else {
      List<types.TextMessage> _messages = [];
      _messages.addAll(messages);
      _messages[0] = types.TextMessage(
        author: messages[0].author,
        createdAt: messages[0].createdAt,
        id: messages[0].id,
        text: '検索結果を解析しています… $progress%完了',
        // 吹き出しWidget側で進捗のインジケータ制御に使うのでメタデータとして渡す
        metadata: {'progress': progress},
      );
      messages = _messages;
      notifyListeners();
    }
  }

  void _sendQuestion(String text) async {
    // 既存のconnectionをcloseする
    _connection?.close();

    List<String> previousMessages =
        (currentChatThread?.messages ?? []).map((message) {
      if (message.author == ChatUser.chatBot) {
        return 'AI: ${message.text}';
      } else if (message.author == ChatUser.user) {
        return 'Human: ${message.text}';
      } else {
        return '';
      }
    }).toList();

    print('send previous: $previousMessages');

    final questionBody = SendQuestionRequest(
      categoryId: categories[selectedCategoryIndex].id,
      text: text,
      previousMessages: previousMessages,
    );
    isShowLoadingForStream = true;
    messageStatus = StreamMessageResponseStatus.isFirst;
    actionInfoMessageStatus = StreamMessageResponseStatus.isFirst;
    webContentsScrapingProgressMessageStatus =
        StreamMessageResponseStatus.isFirst;
    twoDimensionSourceURLList.clear();
    notifyListeners();

    try {
      // 新しいコネクションを作成して変数に格納
      _connection = await _chatRepository.sendQuestion(
          questionBody, _answerResponseController);
    } on Exception catch (exception) {
      _errorController.add(exception);
    }
  }

  void _resetChatPageData() {
    currentChatThread = ChatThread(
      id: 0,
      messages: [],
      sourceUrlProvidedMessages: [],
    );
    // connectionをcloseする
    _connection?.close();
    messages = [];
    isShowLoadingForStream = false;

    notifyListeners();
  }
}

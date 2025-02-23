import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:sample_rag_chat/repositories/chat_repository.dart';
import 'package:sample_rag_chat/repositories/ping_repository.dart';
import '../../constants/chat_user.dart';
import '../../data_models/answer/answer.dart';
import '../../data_models/answer_type.dart';
import '../../data_models/chat.dart';
import '../../data_models/question/question.dart';
import '../../data_models/question/stream_message_response_status.dart';
import '../../utilities/chat_page_util.dart';
import '../../utilities/sse.dart';

/// ViewModelへのグローバルアクセスを提供するProvider
final chatViewModel = ChangeNotifierProvider(
  (context) => ChatViewModel(),
);

/// ViewModel
class ChatViewModel with ChangeNotifier {
  final _errorController = StreamController<Exception>.broadcast();

  Stream<Exception> get errorStream => _errorController.stream;

  final _pingRepository = PingRepository();
  final _chatRepository = ChatRepository();

  List<types.TextMessage> messages = [];
  bool isShowLoadingForStream = false;

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
  List<String> waitingStrings = [];

  // 1回の回答のためにGoogle検索が任意の回数実行される可能性があるため、最後に送られてきたソースURLリストだけを採用するために、2次元配列にしている
  List<List<String>> twoDimensionSourceURLList = [];
  bool isURLString = false;
  Sse? _connection;
  StreamController _answerResponseController = StreamController();
  StreamSubscription<dynamic>? _answerResponseSubscription;

  /// MARK: - Viewの初期化タイミングに合わせて行う処理
  void onViewInitState() async {
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

  void resetChatPageData() {
    currentChatThread = null;
    // connectionをcloseする
    _connection?.close();
    messages = [];
    isShowLoadingForStream = false;

    notifyListeners();
  }

  Future<void> addMessage(types.TextMessage message) async {
    List<types.TextMessage> _messages = [];
    _messages.addAll(messages);
    _messages.insert(0, message);
    messages = _messages;
    notifyListeners();
    currentChatThread?.messages += [message];
  }

  void onTapSendButton(String text) {
    final textMessage = types.TextMessage(
      author: ChatUser.user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: ChatPageUtil.randomString(),
      text: text,
    );

    // 自分の入力メッセージをスレッドに表示
    addMessage(textMessage);

    // 入力内容をAIに送信
    _sendQuestion(textMessage.text);
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

  void _handleStreamAnswerResponseValue(dynamic value) {
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
      AnswerType answerType =
          AnswerType.values[streamAnswerResponse.answerTypeId];

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
          twoDimensionSourceURLList += [streamAnswerResponse.sourceUrlList ?? []];
          break;

        // 最終的な回答の断片を表示
        case AnswerType.partOfFinalAnswerText:
          final text = streamAnswerResponse.partOfFinalAnswerText;
          _addStreamMessage(text ?? '');
          break;
      }
    }
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

  void _sendQuestion(String text) async {
    // 既存のconnectionをcloseする
    _connection?.close();

    final questionBody = SendQuestionRequest(
      categoryId: 0,
      text: '',
      previousMessages: [],
    );
    isShowLoadingForStream = true;
    messageStatus = StreamMessageResponseStatus.isFirst;
    actionInfoMessageStatus = StreamMessageResponseStatus.isFirst;
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
}

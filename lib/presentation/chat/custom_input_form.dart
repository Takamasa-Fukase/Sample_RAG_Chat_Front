import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

/// チャット画面のクラス
class CustomInputForm extends StatefulWidget {
  final Function(String) onSendButtonPressed;
  final int maxTextCount;
  final bool isLoading;

  const CustomInputForm(
      {Key? key,
      required this.onSendButtonPressed,
      required this.maxTextCount,
      required this.isLoading})
      : super(key: key);

  @override
  State<CustomInputForm> createState() => _CustomInputFormState();
}

class _CustomInputFormState extends State<CustomInputForm>
    with SingleTickerProviderStateMixin {
  final _textEditingController = TextEditingController();

  // final _maxTextCount = 100;
  int? _maxLines;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: widget.isLoading ? 1.0 : 0.0, // isLoadingに合わせて初期値を設定
    );
  }

  @override
  void didUpdateWidget(CustomInputForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.animateTo(1.0, duration: Duration.zero); // 出現時はすぐに表示
      } else {
        _controller.reverse(); // 消えるときだけアニメーションを使う
      }
    }
  }

  late final _inputFocusNode = FocusNode(
    onKeyEvent: (node, event) {
      // Enter + Shiftが押されたケース。改行させる。
      if (event.logicalKey == LogicalKeyboardKey.enter &&
          HardwareKeyboard.instance.logicalKeysPressed.any(
            (el) => <LogicalKeyboardKey>{
              LogicalKeyboardKey.shiftLeft,
              LogicalKeyboardKey.shiftRight,
            }.contains(el),
          )) {
        // 改行が実行される（何もハンドリングしなかった時のignoredと違ってこっちだと何で改行が良い感じに実行されるようになるのかは不明）
        return KeyEventResult.ignored;
        // Enterだけ押されたケース。条件が揃っていれば送信処理を走らせる
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // 日本語の確定されていない下線付き状態である（変換の為のスペースキーをまだ一回も押していない状態）
        if (_textEditingController.value.composing != TextRange.empty) {
          return KeyEventResult.handled;
          // 日本語の変換中の選択中状態である（日本語変換中に自動で選択状態になってるやつ。一回以上スペースキーを押してて、確定していない間はここのケースに入る）
        } else if (!_textEditingController.selection.isCollapsed) {
          return KeyEventResult.handled;
          // 下線状態でも変換中の選択中状態でも無いので、送信処理を走らせる前にバリデーションチェックする
        } else {
          // 空白と改行を削除した状態でのテキストが空じゃなく、文字数バリデーションも通ってるので、送信処理を行う
          if (event is KeyDownEvent &&
              (_isTextCountValid(_textEditingController.text) &&
                  (_textEditingController.text.trim()).isNotEmpty)) {
            // 送信処理を走らせる
            _sendText();
          }
          return KeyEventResult.handled;
        }
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    final String textString = _textEditingController.text;
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            if (_controller.isDismissed) {
              return Container();
            }
            return SizeTransition(
              sizeFactor: _controller,
              axis: Axis.vertical,
              child: Align(
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
          child:
              Lottie.asset("lottie/lottie.json", width: 100, height: 70),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 6, left: 48, right: 54, bottom: 10),
                          child: TextFormField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: _maxLines,
                            style: const TextStyle(color: Colors.black87),
                            cursorWidth: 1.5,
                            decoration: InputDecoration(
                              hintText: '気になることを質問してみましょう',
                              hintStyle: const TextStyle(color: Colors.grey),
                              counterStyle: TextStyle(
                                color: _isTextCountValid(textString)
                                    ? Colors.grey
                                    : Colors.redAccent,
                              ),
                              errorStyle: TextStyle(
                                color: _isTextCountValid(textString)
                                    ? Colors.transparent
                                    : Colors.redAccent,
                              ),
                              errorText: '${widget.maxTextCount}文字以下で入力してください',
                              errorBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            focusNode: _inputFocusNode,
                            onChanged: (text) {
                              setState(() {
                                _maxLines = '\n'
                                            .allMatches(
                                                _textEditingController.text)
                                            .length >=
                                        4
                                    ? 5
                                    : null;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${textString.length}/${widget.maxTextCount}',
                          style: TextStyle(
                            color: _isTextCountValid(textString)
                                ? Colors.grey
                                : Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 45,
                      child: sendButton(_isTextCountValid(textString) &&
                          textString.isNotEmpty),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isTextCountValid(String text) {
    return text.length <= widget.maxTextCount;
  }

  void _sendText() {
    widget.onSendButtonPressed(_textEditingController.text);
    _textEditingController.clear();
  }

  /// 送信ボタン
  Widget sendButton(bool isEnabled) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0.0),
        minimumSize: MaterialStateProperty.all<Size>(const Size(20, 18)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(10.0)),
      ),
      onPressed: isEnabled
          ? () {
              // 送信ボタン押下時の処理
              _sendText();
            }
          : null,
      child: SizedBox(
        width: 20,
        height: 18,
        child: Icon(Icons.send),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AgentActionInfoBubble extends StatelessWidget {
  const AgentActionInfoBubble(
      {required this.messageTextWidget, required this.textMessage, Key? key})
      : super(key: key);

  final Widget messageTextWidget;
  final types.TextMessage textMessage;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 0,
                    width: 8,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: SizedBox(
                      width: 0,
                      child: Icon(Icons.check, size: 20, color: Colors.green),
                    ),
                  ),
                  Flexible(  // Flexibleを追加
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      // ChatWidgetから渡されたmessage部分のwidgetをここに配置
                      child: messageTextWidget),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

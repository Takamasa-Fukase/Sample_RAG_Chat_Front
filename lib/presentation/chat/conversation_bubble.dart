import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sample_rag_chat/presentation/chat/source_url_list_widget.dart';

import '../../data_models/chat.dart';
import '../../utilities/chat_page_util.dart';
import '../../utilities/url_launcher_util.dart';

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({
    required this.messageTextWidget,
    required this.textMessage,
    required this.currentChatThread,
    Key? key,
  }) : super(key: key);

  final Widget messageTextWidget;
  final types.TextMessage textMessage;
  final ChatThread? currentChatThread;

  @override
  Widget build(BuildContext context) {
    final isSentByAI = ChatPageUtil.isSentByAI(textMessage);
    final sourceUrlList = ChatPageUtil.getSourceURLListFromMessage(
        currentChatThread, textMessage);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            decoration: BoxDecoration(
              color: (isSentByAI)
                  ? Colors.white
                  : const Color.fromRGBO(72, 113, 239, 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Markdown(
                  data: textMessage.text,
                  shrinkWrap: true,
                  selectable: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onTapLink: (text, href, title) {
                    if (href == null) {
                      return;
                    }
                    UrlLauncherUtil.launchURL(href);
                  },
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
                  styleSheet: MarkdownStyleSheet(
                    p: isSentByAI
                        ? const TextStyle()
                        : const TextStyle(color: Colors.white),
                  ),
                ),

                // ソースURLがある場合だけソースURL表示Widgetを配置する
                (sourceUrlList.isNotEmpty)
                    ? SourceUrlListWidget(urlList: sourceUrlList)
                    : Container(),
              ],
            )),
      ],
    );
  }
}

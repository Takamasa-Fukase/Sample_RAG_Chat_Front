import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sample_rag_chat/constants/chat_page_const.dart';
import 'package:sample_rag_chat/presentation/chat/components/source_url_list_widget.dart';
import '../../../constants/chat_user.dart';
import '../../../constants/custom_colors.dart';
import '../../../data_models/chat.dart';
import '../../../utilities/chat_page_util.dart';
import '../../../utilities/url_launcher_util.dart';
import '../../common/responsive_widget.dart';

class ConversationBubble extends StatelessWidget {
  const ConversationBubble({
    required this.textMessage,
    required this.currentChatThread,
    Key? key,
  }) : super(key: key);

  final types.TextMessage textMessage;
  final ChatThread? currentChatThread;

  @override
  Widget build(BuildContext context) {
    final isSentByAI = ChatPageUtil.isSentByAI(textMessage);
    final sourceUrlList = ChatPageUtil.getSourceURLListFromMessage(
        currentChatThread, textMessage);

    final sideMenuWidth = (ResponsiveWidget.isSmallScreen(context))
        ? 0
        : ChatPageConst.sideMenuWidth;
    final chatWindowWidth = (ResponsiveWidget.isLargeScreen(context))
        ? (MediaQuery.of(context).size.width - sideMenuWidth) * 0.8
        : MediaQuery.of(context).size.width - sideMenuWidth;

    return GestureDetector(
        onDoubleTap: () {},
        child: Container(
          alignment: (textMessage.author == ChatUser.user)
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: chatWindowWidth * 0.85),
              child: Container(
                  decoration: BoxDecoration(
                    color:
                        (isSentByAI) ? CustomColor.goldLeaf : CustomColor.paper,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: (isSentByAI)
                          ? CustomColor.paper
                          : CustomColor.blackSteel,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    /// 外側のColumnでは「詳細資料：」の部分を左寄せにするために.startを指定
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: (sourceUrlList.isNotEmpty)
                            ? BoxDecoration(
                                border: Border(
                                /// Dividerの代わりにボトムにだけ枠線を描画している
                                /// （Dividerだと横幅を指定しないと最大限に広がってしまうが、なるべく小さくしたい時には使えない為）
                                bottom: BorderSide(
                                    color: CustomColor.paper, width: 0.5),
                              ))
                            : null,
                        child: Column(
                          /// 内側のColumnではフィードバックボタン部分を右寄せにするために.end指定
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),

                              /// Markdown()だとfitContent（横幅をなるべく小さくフィットさせる）的な実装が恐らく不可能なのでMarkdownBody()に差し替えた
                              child: MarkdownBody(
                                data: textMessage.text,

                                /// 横幅をなるべく中身の要素に合わせてフィットさせる為にfitContent:trueを指定する
                                fitContent: true,
                                shrinkWrap: true,
                                selectable: true,
                                onTapLink: (text, href, title) {
                                  if (href == null) {
                                    return;
                                  }
                                  UrlLauncherUtil.launchURL(href);
                                },
                                styleSheetTheme:
                                    MarkdownStyleSheetBaseTheme.platform,
                                styleSheet: MarkdownStyleSheet(
                                  p: isSentByAI
                                      ? const TextStyle(
                                          color: CustomColor.blackSteel,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)
                                      : const TextStyle(
                                          color: CustomColor.blackSteel,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ソースURLがある場合だけソースURL表示Widgetを配置する
                      (sourceUrlList.isNotEmpty)
                          ? SourceUrlListWidget(urlList: sourceUrlList)

                          /// 空のContainerを返す際に明示的に横幅を0に指定しないと最大限に広がってしまう為指定する
                          : Container(width: 0),
                    ],
                  ))),
        ));
  }
}

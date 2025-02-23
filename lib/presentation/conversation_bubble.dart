// import 'package:arsaga_company_gpt_app/const/good_or_bad.dart';
// import 'package:arsaga_company_gpt_app/model/chat.dart';
// import 'package:arsaga_company_gpt_app/utility/chat_page_util.dart';
// import 'package:arsaga_company_gpt_app/widget/components/chat_page/source_url_list_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_markdown/flutter_markdown.dart';
// import '../../../utility/url_launcher_util.dart';
//
// class ConversationBubble extends StatelessWidget {
//   const ConversationBubble({
//     required this.messageTextWidget,
//     required this.textMessage,
//     required this.currentChatThread,
//     required this.onTapFeedbackButton,
//     Key? key,
//   }) : super(key: key);
//
//   final Widget messageTextWidget;
//   final types.TextMessage textMessage;
//   final ChatThread? currentChatThread;
//   final Function(types.TextMessage, GoodOrBad) onTapFeedbackButton;
//
//   @override
//   Widget build(BuildContext context) {
//     final isSentByAI = ChatPageUtil.isSentByAI(textMessage);
//     final isIntroductionText =
//         ChatPageUtil.isIntroductionText(currentChatThread, textMessage);
//     final goodOrBad =
//         ChatPageUtil.getGoodOrBadForThisMessage(currentChatThread, textMessage);
//     final isFeedbackButtonVisible = isSentByAI && !isIntroductionText;
//     final sourceUrlList = ChatPageUtil.getSourceURLListFromMessage(
//         currentChatThread, textMessage);
//
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//             decoration: BoxDecoration(
//               color: (isSentByAI)
//                   ? Colors.white
//                   : const Color.fromRGBO(72, 113, 239, 1),
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Markdown(
//                   data: textMessage.text,
//                   shrinkWrap: true,
//                   selectable: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   onTapLink: (text, href, title) {
//                     if (href == null) {
//                       return;
//                     }
//                     UrlLauncherUtil.launchURL(href);
//                   },
//                   styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
//                   styleSheet: MarkdownStyleSheet(
//                     p: isSentByAI
//                         ? const TextStyle()
//                         : const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Visibility(
//                       visible: isFeedbackButtonVisible,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               if (goodOrBad == null) {
//                                 onTapFeedbackButton(
//                                     textMessage, GoodOrBad.good);
//                               }
//                             },
//                             // padding: EdgeInsets.zero,
//                             icon: Icon(
//                               (goodOrBad == GoodOrBad.good
//                                   ? Icons.thumb_up
//                                   : Icons.thumb_up_alt_outlined),
//                               size: 20,
//                               color: (goodOrBad == GoodOrBad.good
//                                   ? const Color.fromRGBO(72, 113, 239, 1)
//                                   : Colors.grey),
//                             ),
//                             enableFeedback: true,
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               if (goodOrBad == null) {
//                                 onTapFeedbackButton(textMessage, GoodOrBad.bad);
//                               }
//                             },
//                             // padding: EdgeInsets.zero,
//                             icon: Icon(
//                               (goodOrBad == GoodOrBad.bad
//                                   ? Icons.thumb_down
//                                   : Icons.thumb_down_alt_outlined),
//                               size: 20,
//                               color: (goodOrBad == GoodOrBad.bad
//                                   ? const Color.fromRGBO(72, 113, 239, 1)
//                                   : Colors.grey),
//                             ),
//                             enableFeedback: true,
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 // ソースURLがある場合だけソースURL表示Widgetを配置する
//                 (sourceUrlList.isNotEmpty)
//                     ? SourceUrlListWidget(urlList: sourceUrlList)
//                     : Container(),
//               ],
//             )),
//       ],
//     );
//   }
// }

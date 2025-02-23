// import 'package:arsaga_company_gpt_app/const/chat_user.dart';
// import 'package:arsaga_company_gpt_app/model/chat.dart';
// import 'package:arsaga_company_gpt_app/utility/chat_page_util.dart';
// import 'package:arsaga_company_gpt_app/widget/components/chat_page/agent_action_info_bubble.dart';
// import 'package:arsaga_company_gpt_app/widget/components/chat_page/conversation_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import '../../../const/good_or_bad.dart';
// import '../../../const/localization.dart';
// import '../../../utility/color_setting.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'custom_input_form.dart';
//
// class ChatListView extends StatelessWidget {
//   const ChatListView(
//       {Key? key,
//       required this.width,
//       required this.user,
//       required this.messages,
//       required this.currentChatThread,
//       required this.isShowLoadingForStream,
//       required this.onTapExpandChatAreaButton,
//       required this.onTapSendButton,
//       required this.onTapNewChatButton,
//       required this.onTapFeedbackButton})
//       : super(key: key);
//
//   final double width;
//   final types.User user;
//   final List<types.Message> messages;
//   final ChatThread? currentChatThread;
//   final bool isShowLoadingForStream;
//   final Function() onTapExpandChatAreaButton;
//   final Function(String) onTapSendButton;
//   final Function() onTapNewChatButton;
//   final Function(types.TextMessage, GoodOrBad) onTapFeedbackButton;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       // 拡張表示用のバー
//       GestureDetector(
//           onTap: onTapExpandChatAreaButton,
//           child: Container(
//             margin: const EdgeInsets.all(8),
//             height: 8,
//             width: width / 5,
//             decoration: const BoxDecoration(
//               color: disableLightGrey,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//           )),
//       Expanded(
//           child: Chat(
//         theme: const DefaultChatTheme(
//           // primaryColor: Colors.white, // メッセージの背景色の変更
//           userAvatarNameColors: [Colors.transparent], // ユーザー名の文字色の変更
//           // 背景画像を表示する為に透過
//           backgroundColor: Colors.transparent,
//           // チャットの投稿時間を非表示
//           dateDividerTextStyle: TextStyle(color: Colors.transparent),
//         ),
//
//         // 自作のカスタムの吹き出しバブルを入れ込む
//         bubbleBuilder: (messageTextWidget,
//             {required message, required nextMessageInGroup}) {
//           final textMessage = message as types.TextMessage;
//           // AIのアクション表示用のバブルを使用
//           if (textMessage.author == ChatUser.actionInfo) {
//             return AgentActionInfoBubble(
//                 messageTextWidget: messageTextWidget, textMessage: textMessage);
//
//             // AIと人間の会話で共通のバブルを使用
//           } else {
//             return ConversationBubble(
//                 messageTextWidget: messageTextWidget,
//                 textMessage: textMessage,
//                 currentChatThread: currentChatThread,
//                 onTapFeedbackButton: onTapFeedbackButton);
//           }
//         },
//         messages: messages,
//         // カスタム入力フォーム側でハンドリングするためここでは処理は行わない
//         onSendPressed: (message) {},
//         // ここで自分（右側に表示）がどのユーザーなのかを設定して認識させる
//         user: user,
//         // これは相手（左に表示）だけだった気がする
//         showUserAvatars: false,
//         customBottomWidget: CustomInputForm(
//           onSendButtonPressed: onTapSendButton,
//           onTapNewChatButton: onTapNewChatButton,
//           isLoading: isShowLoadingForStream,
//           maxTextCount: 1000,
//         ),
//         l10n: const ChatL10nJa(),
//         // メッセージをダブルタップでクリップボードにテキストをコピー＆トースト表示
//         onMessageDoubleTap: (_, message) {
//           ChatPageUtil.copyTextToClipboard(message);
//         },
//       )),
//     ]);
//   }
// }

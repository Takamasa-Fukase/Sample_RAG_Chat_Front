// import 'dart:ui';
// import 'package:arsaga_company_gpt_app/const/category/doctor_type.dart';
// import 'package:arsaga_company_gpt_app/const/category/index_uploader_name.dart';
// import 'package:arsaga_company_gpt_app/const/chat_page_mode.dart';
// import 'package:arsaga_company_gpt_app/const/chat_user.dart';
// import 'package:arsaga_company_gpt_app/const/index_registration_transition_type.dart';
// import 'package:arsaga_company_gpt_app/const/side_menu_tab_type.dart';
// import 'package:arsaga_company_gpt_app/model/app_state.dart';
// import 'package:arsaga_company_gpt_app/utility/chat_page_util.dart';
// import 'package:arsaga_company_gpt_app/utility/color_setting.dart';
// import 'package:arsaga_company_gpt_app/utility/confirmation_dialog_util.dart';
// import 'package:arsaga_company_gpt_app/utility/first_login_checker.dart';
// import 'package:arsaga_company_gpt_app/utility/privacypolicy_dialog_util.dart';
// import 'package:arsaga_company_gpt_app/view_model/side_menu_view_model.dart';
// import 'package:arsaga_company_gpt_app/widget/components/chat_page/chat_list_view.dart';
// import 'package:arsaga_company_gpt_app/widget/components/chat_page/feedback_dialog.dart';
// import 'package:arsaga_company_gpt_app/widget/components/common/custom_app_bar_for_large_screen.dart';
// import 'package:arsaga_company_gpt_app/widget/components/common/custom_app_bar_for_small_screen.dart';
// import 'package:arsaga_company_gpt_app/widget/components/common/custom_rounded_border_button.dart';
// import 'package:arsaga_company_gpt_app/widget/components/index_uploader.dart';
// import 'package:arsaga_company_gpt_app/widget/components/common/responsive_widget.dart';
// import 'package:arsaga_company_gpt_app/widget/components/user_info_dialog/user_info_dialog.dart';
// import 'package:arsaga_company_gpt_app/widget/page/register_page.dart';
// import 'package:arsaga_company_gpt_app/widget/page/tutorial_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'dart:async';
// import '../../const/good_or_bad.dart';
// import 'dart:js' as js;
// import '../../utility/error_handler.dart';
// import '../../view_model/chat_page_view_model.dart';
// import '../../state/chat/chat_state.dart' as chat_state;
// import '../components/side_menu/side_menu.dart';
// import 'category_setting_page.dart';
//
// class ChatPage extends HookConsumerWidget {
//   final bool showLoginDialog;
//   final String demoQuestion;
//
//   ChatPage({this.showLoginDialog = false, this.demoQuestion = '', Key? key})
//       : super(key: key);
//
//   final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   OverlayEntry? _overlayEntry;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (AppState.user?.data.company.companyInformation.tutorialState ==
//         "complete") {
//       return _buildChatPage(context, ref);
//     } else {
//       return const TutorialPage();
//     }
//   }
//
//   Widget _buildChatPage(BuildContext context, WidgetRef ref) {
//     final viewModel = ref.read(chatViewModel.notifier);
//     final chat_state.ChatState viewModelState = ref.watch(chatViewModel);
//     final screenSize = MediaQuery.of(context).size;
//     final debounce = ref.read(debounceProvider.notifier);
//
//     // TODO: - ここら辺の定数など色々直したい（が一旦優先度は低い）
//     // double smallWidth = 326;
//     double largeWidth = 456;
//     double chatPageHeight = screenSize.height;
//     double defaultChatPageHeight = chatPageHeight * 0.53; // 初期状態のチャット画面の高さ
//     double expandedChatPageHeight = chatPageHeight * 0.9; // 拡張時のチャット画面の高さ
//
//     /// 初期化処理としてuseEffectを使っている
//     useEffect(() {
//       viewModel.onViewInitState();
//
//       // TODO: - 確かSaaS版は表示できていないので直す
//       // おかえりスナックバー
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         handleLoginDialog(context);
//       });
//
//       /// MARK: - ViewModelからのイベントを購読して処理を行う
//       final showLimitExceededDialogSubscription =
//           viewModel.showLimitExceededDialogStream.listen((_) {
//         _showExceededSoftLimitDialog(context, viewModel);
//       });
//
//       final showContactingAboutUpgradeCompletedDialogSubscription =
//       viewModel.showContactingAboutUpgradeCompletedDialogStream.listen((_) {
//         _showContactingAboutUpgradeCompletedDialog(context);
//       });
//
//       final transitToRegisterPageSubscription =
//       viewModel.transitToRegisterPageStream.listen((_) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const RegisterPage(showLogoutDialog: true)),
//         );
//       });
//
//       final errorSubscription = viewModel.errorStream.listen((event) {
//         debounce.debounce(const Duration(milliseconds: 500), () {
//           ErrorHandler.handleException(context, event);
//         });
//       });
//
//       /// 解放処理
//       return () {
//         viewModel.onViewDispose();
//         showLimitExceededDialogSubscription.cancel();
//         showContactingAboutUpgradeCompletedDialogSubscription.cancel();
//         transitToRegisterPageSubscription.cancel();
//         errorSubscription.cancel();
//       };
//
//       /// MEMO: - 初期化処理に使っている為、下記のkeysは空配列のままにしておくこと（変更される可能性のある値をいれてしまうと複数回呼ばれてしまって初期化処理に使えない為）
//     }, const []);
//
//     /// ChatPageのメインコンテンツの描画処理
//     return ScaffoldMessenger(
//         key: _scaffoldMessengerKey,
//         child: Scaffold(
//             key: _scaffoldStateKey,
//             appBar: ResponsiveWidget.isSmallScreen(context)
//                 ? customAppBarForSmallScreen(
//                     leadingWidget: IconButton(
//                         icon: Image.asset('assets/icon-SPmenu.png'),
//                         onPressed: _scaffoldStateKey.currentState?.openDrawer),
//                     onTapUserIconButton: () {
//                       _showUserInfoDialog(context, viewModel);
//                     })
//                 : customAppBarForLargeScreen(
//                     screenSize: screenSize,
//                     onTapUserIconButton: () {
//                       _showUserInfoDialog(context, viewModel);
//                     }),
//             drawer: ResponsiveWidget.isSmallScreen(context)
//             /// カテゴリリスト（小サイズの時はドロワー内に表示する）
//                 ? Drawer(
//                     backgroundColor: Colors.transparent,
//                     width: largeWidth,
//                     child: Container(
//                         padding: MediaQuery.of(context).size.width < 391
//                             ? const EdgeInsets.only(right: 32, top: 8)
//                             : const EdgeInsets.only(right: 0, top: 8),
//                         child: SizedBox(
//                           width: 456,
//                           child: SideMenu(
//                             isPutOnDrawer: true)),
//                   ))
//                 : null,
//             body: Stack(
//               children: [
//                 // 背景の廊下画像
//                 Container(
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/background_image.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white.withOpacity(0.5),
//                 ),
//                 Row(
//                   children: [
//                     /// カテゴリリスト（中サイズ以上の画面の時は常時表示する）
//                     Visibility(
//                       visible: !ResponsiveWidget.isSmallScreen(context),
//                       child: SizedBox(
//                           width: 456,
//                           child: SideMenu(
//                             isPutOnDrawer: true,)),
//                     ),
//
//                     if (viewModelState.pageMode == ChatPageMode.chat)
//                       Expanded(
//                           child: Stack(
//                         children: [
//                           // 人物画像
//                           Positioned(
//                             top: screenSize.height * 0.03,
//                             // インサイトくんの時は浮かせる
//                             bottom:
//                             // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                             (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? 0
//                                     : screenSize.height * 0.26,
//                             left: 0,
//                             right: 0,
//                             child: Center(
//                               child: Image.asset(
//                                 // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                                 (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? (viewModel.currentChatThread
//                                     ?.category)?.personImageUrl ?? '' : 'insight_kun.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//
//                           // チャットの窓部分（ギャルゲ仕様）
//                           Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: Stack(
//                               alignment: Alignment.bottomCenter,
//                               children: <Widget>[
//                                 // 領域確保用の透明なやつ
//                                 SizedBox(
//                                   height: viewModelState.isExpandedChatListView
//                                       ? expandedChatPageHeight + 36
//                                       : defaultChatPageHeight + 36,
//                                   width: screenSize.width,
//                                 ),
//
//                                 Visibility(
//                                   visible: (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation),
//                                   child: Positioned(
//                                     top: 0,
//                                     right: 16,
//                                     child: CustomRoundedBorderIconButton(
//                                         foregroundColor: buttonPaleBlue,
//                                         borderColor: buttonPaleBlue,
//                                         leadingIcon: Image.asset(
//                                           'assets/icons/icon_light_bulb.png',
//                                           color: buttonPaleBlue,
//                                           width: 13,
//                                           height: 13,
//                                         ),
//                                         // TODO: - カテゴリ管理がバックエンド側になったらdoctorTypeを消すので差し替える
//                                         title: viewModel
//                                             .currentChatThread
//                                             ?.category.doctorType
//                                             .indexUploaderName ??
//                                             '',
//                                         onTap: () {
//                                           showIndexAddDialog(
//                                               context,
//                                               viewModel,
//                                               IndexRegistrationTransitionType
//                                                   .fromChatPage, (type) {
//                                             // 安江さんが喋る
//                                             viewModel.addMessage(types.TextMessage(
//                                                 author: ChatUser.chatBot,
//                                                 id: ChatPageUtil.randomString(),
//                                                 text:
//                                                     '学習しました！\f教えていただきありがとうございます！\fまた色んな情報を教えてくださいね！'));
//                                           });
//                                         }),
//                                   ),
//                                 ),
//
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 16, right: 16),
//                                   child: Container(
//                                       decoration: BoxDecoration(
//                                         border:
//                                             Border.all(color: Colors.black54),
//                                         borderRadius: const BorderRadius.only(
//                                             topRight: Radius.circular(10)),
//                                         color: Colors.black.withOpacity(0.16),
//                                       ),
//                                       height:
//                                           viewModelState.isExpandedChatListView
//                                               ? expandedChatPageHeight
//                                               : defaultChatPageHeight,
//                                       width: screenSize.width,
//                                       child: Stack(
//                                         clipBehavior: Clip.none,
//                                         children: [
//                                           /// 人物名の表示
//                                           Positioned(
//                                             top: -32,
//                                             left: -1,
//                                             child: Container(
//                                                 decoration: const BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   10),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   30)),
//                                                   color: Color.fromRGBO(
//                                                       92, 97, 106, 1),
//                                                 ),
//                                                 height: 32,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 10,
//                                                           left: 16,
//                                                           right: 28,
//                                                           bottom: 0),
//                                                   child: Text(
//                                                     // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                                                     (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? (viewModel.currentChatThread
//                                                         ?.category)?.personName ?? '' : 'インサイトくん',
//                                                     style: const TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.w700,
//                                                       fontSize: 12,
//                                                       height: 1.2,
//                                                     ),
//                                                   ),
//                                                 )),
//                                           ),
//
//                                           // 擦りガラス風エフェクト部分
//                                           Positioned(
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   const BorderRadius.only(
//                                                       topRight:
//                                                           Radius.circular(10)),
//                                               child: BackdropFilter(
//                                                 filter: ImageFilter.blur(
//                                                     sigmaX: 10, sigmaY: 10),
//                                                 child: Container(
//                                                   // color: Colors.black.withOpacity(0),
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                           // color: Colors.black.withOpacity(0.3),
//                                                           color: Color.fromRGBO(
//                                                               209,
//                                                               209,
//                                                               209,
//                                                               0.3)),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//
//                                           ChatListView(
//                                               width: ResponsiveWidget
//                                                       .isSmallScreen(context)
//                                                   ? screenSize.width
//                                                   : screenSize.width -
//                                                       largeWidth,
//                                               user: ChatUser.user,
//                                               messages: viewModelState.messages,
//                                               currentChatThread:
//                                                   viewModel.currentChatThread,
//                                               isShowLoadingForStream: viewModelState
//                                                   .isShowLoadingForStream,
//                                               onTapExpandChatAreaButton: viewModel
//                                                   .onTapExpandChatListViewButton,
//                                               onTapSendButton:
//                                                   viewModel.onTapSendButton,
//                                               onTapNewChatButton:
//                                                   viewModel.onTapNewChatButton,
//                                               onTapFeedbackButton:
//                                                   (message, goodOrBad) {
//                                                 _showReviewDialog(
//                                                     context, goodOrBad, (text) {
//                                                   viewModel.sendRatedAnswer(
//                                                       answerMessage: message,
//                                                       goodOrBad: goodOrBad,
//                                                       feedbackText: text);
//                                                 });
//                                               }),
//                                         ],
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ))
//                     else
//                       // 編集モード
//                       Expanded(
//                           child: CategorySettingPage(onTapCanceled: () {
//                           viewModel.changeChatPageModeTo(ChatPageMode.chat);
//                         },
//                       ))
//                   ],
//                 ),
//               ],
//             )));
//   }
//
//   void executeJavaScript(String javaScriptCode) {
//     js.context.callMethod('eval', [javaScriptCode]);
//   }
//
//   void handleLoginDialog(BuildContext context) {
//     if (showLoginDialog) {
//       _scaffoldMessengerKey.currentState!.showSnackBar(
//         SnackBar(
//           content: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Text(
//               FirstLoginChecker.isNewUser()
//                   ? "はじめまして、${auth.currentUser?.displayName ?? "No Name"}さん！"
//                   : "おかえりなさい、${auth.currentUser?.displayName ?? "No Name"}さん！",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           backgroundColor: seaGreen.withOpacity(0.9),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: EdgeInsets.only(
//             left: ResponsiveWidget.isSmallScreen(context) ? 16 : 80,
//             right: ResponsiveWidget.isSmallScreen(context) ? 16 : 80,
//             bottom: MediaQuery.of(context).size.height - 140,
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   void _showExceededSoftLimitDialog(
//       BuildContext context, ChatViewModel viewModel) {
//     showConfirmationDialog(
//         context,
//         '会話数もしくはインデックス数の上限を超えました。\n有料版のARSAGA INSIGHT ENGINE powered by GPTに変更しますか？',
//         '※ボタンの”有料プランの問い合わせ”を押下すると、有料プランの契約に関する情報を送るための問い合わせ受付として送信されます。”キャンセル”を押すと、Saas版を引き続きご利用できます。',
//         'キャンセル',
//         '有料プランの問い合わせ', viewModel.updateCanPaymentStatus);
//   }
//
//   void _showContactingAboutUpgradeCompletedDialog(BuildContext context) {
//     showConfirmationDialog(context, 'ありがとうございます！有料プランの問い合わせを受け付けました。',
//         '追って弊社からメールアドレスへ2営業日内にご連絡差し上げますので、よろしくお願いします。', null, '閉じる', () {
//         Navigator.pop(context);
//     });
//
//     // GTMのタグを発火させる
//     executeJavaScript("dataLayer.push({'event': 'inquiry_complete'});");
//   }
//
//   void _showUserInfoDialog(BuildContext context, ChatViewModel viewModel) {
//     if (_overlayEntry == null) {
//       _overlayEntry = _createUserInfoDialogOverlayEntry(context, viewModel);
//       Overlay.of(context).insert(_overlayEntry!);
//     }
//   }
//
//   void _closeUserInfoDialog() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//
//   OverlayEntry _createUserInfoDialogOverlayEntry(
//       BuildContext context, ChatViewModel viewModel) {
//     return OverlayEntry(
//         maintainState: true,
//         builder: (context) => UserInfoDialog(onTapOutside: () {
//               _closeUserInfoDialog();
//             }, onTapContactAboutPaymentButton: () {
//               _closeUserInfoDialog();
//               _showContactingAboutUpgradeConfirmationDialog(context, viewModel);
//             }, onTapPrivacyPolicyButton: () {
//               _closeUserInfoDialog();
//               showPrivacyPolicyDialog(context, '閉じる');
//             }, onTapLogoutButton: () {
//               _closeUserInfoDialog();
//               showConfirmationDialog(context, 'ログアウトしますか？', '', 'キャンセル', 'ログアウト', viewModel.onTapLogoutButton);
//             }));
//   }
//
//   Future _showContactingAboutUpgradeConfirmationDialog(
//       BuildContext context, ChatViewModel viewModel) async {
//     bool sendEmail = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('担当者に連絡します。よろしいでしょうか。'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('はい'),
//               onPressed: () {
//                 Navigator.of(context).pop(true); // ダイアログを閉じてtrueを返す
//               },
//             ),
//             TextButton(
//               child: const Text('いいえ'),
//               onPressed: () {
//                 Navigator.of(context).pop(false); // ダイアログを閉じてfalseを返す
//               },
//             ),
//           ],
//         );
//       },
//     );
//
//     if (sendEmail) {
//       await viewModel.updateCanPaymentStatus();
//     }
//   }
//
//   /// フィードバックのダイアログ表示
//   void _showReviewDialog(BuildContext context, GoodOrBad goodOrBad,
//       Function(String) onPassedFeedbackText) async {
//     final textEditingController = TextEditingController();
//     // 「送信」ボタン押下だけでなく枠外タップで閉じた時もフィードバックを送信するため、「フィードバックしない」を押した時だけdidTapCancelButtonにtrueが返り、それ以外（範囲外タップで閉じた or 送信ボタン押下）ではnull or falseが返るので送信する処理を行う
//     // （Good/Badボタンだけ押してくれたけど文字書くの面倒くて閉じようとした場合も拾いたいため）
//     bool? didTapCancelButton = await showDialog(
//         context: context,
//         builder: (context) {
//           return FeedbackDialog(
//             goodOrBad: goodOrBad,
//             textEditingController: textEditingController,
//           );
//         });
//     if (didTapCancelButton != null && didTapCancelButton) {
//       return;
//     }
//     onPassedFeedbackText(textEditingController.text);
//   }
//
//   // 新規Index追加ボタン押下時のダイアログ表示
//   void showIndexAddDialog(
//       BuildContext context,
//       ChatViewModel viewModel,
//       IndexRegistrationTransitionType type,
//       Function(IndexRegistrationTransitionType) onAddCompleted) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return DoctorWidget(
//             doctorType: viewModel.currentChatThread?.category.doctorType ??
//                 DoctorType.values.first,
//             onAddCompleted: onAddCompleted,
//             type: type);
//       },
//     );
//   }
// }

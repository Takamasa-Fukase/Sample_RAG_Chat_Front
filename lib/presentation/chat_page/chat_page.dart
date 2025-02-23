// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../constants/chat_user.dart';
// import '../../utilities/chat_page_util.dart';
// import '../custom_app_bar_for_large_screen.dart';
// import '../custom_app_bar_for_small_screen.dart';
// import '../responsive_widget.dart';
//
// class ChatPage extends ConsumerStatefulWidget {
//   final bool showLoginDialog;
//   final String demoQuestion;
//
//   ChatPage({this.showLoginDialog = false, this.demoQuestion = '', Key? key})
//       : super(key: key);
//
//   final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModel = ref.read(chatViewModel.notifier);
//     final screenSize = MediaQuery.of(context).size;
//     final debounce = ref.read(debounceProvider.notifier);
//     final double largeWidth = 456;
//     final double chatPageHeight = screenSize.height;
//     final double defaultChatPageHeight = chatPageHeight * 0.53; // 初期状態のチャット画面の高さ
//     final double expandedChatPageHeight = chatPageHeight * 0.9; // 拡張時のチャット画面の高さ
//
//
//     /// 初期化処理としてuseEffectを使っている
//     useEffect(() {
//       viewModel.onViewInitState();
//
//       /// MARK: - ViewModelからのイベントを購読して処理を行う
//       final errorSubscription = viewModel.errorStream.listen((event) {
//         debounce.debounce(const Duration(milliseconds: 500), () {
//           ErrorHandler.handleException(context, event);
//         });
//       });
//
//       /// 解放処理
//       return () {
//         viewModel.onViewDispose();
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
//                 leadingWidget: IconButton(
//                     icon: Image.asset('assets/icon-SPmenu.png'),
//                     onPressed: _scaffoldStateKey.currentState?.openDrawer),
//                 onTapUserIconButton: () {
//
//                 })
//                 : customAppBarForLargeScreen(
//                 screenSize: screenSize,
//                 onTapUserIconButton: () {
//
//                 }),
//
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
//                 Expanded(
//                     child: Stack(
//                       children: [
//                         // 人物画像
//                         Positioned(
//                           top: screenSize.height * 0.03,
//                           // インサイトくんの時は浮かせる
//                           bottom:
//                           // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                           (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? 0
//                               : screenSize.height * 0.26,
//                           left: 0,
//                           right: 0,
//                           child: Center(
//                             child: Image.asset(
//                               // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                               (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? (viewModel.currentChatThread
//                                   ?.category)?.personImageUrl ?? '' : 'insight_kun.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//
//                         // チャットの窓部分（ギャルゲ仕様）
//                         Positioned(
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           child: Stack(
//                             alignment: Alignment.bottomCenter,
//                             children: <Widget>[
//                               // 領域確保用の透明なやつ
//                               SizedBox(
//                                 height: viewModelState.isExpandedChatListView
//                                     ? expandedChatPageHeight + 36
//                                     : defaultChatPageHeight + 36,
//                                 width: screenSize.width,
//                               ),
//
//                               Visibility(
//                                 visible: (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation),
//                                 child: Positioned(
//                                   top: 0,
//                                   right: 16,
//                                   child: CustomRoundedBorderIconButton(
//                                       foregroundColor: buttonPaleBlue,
//                                       borderColor: buttonPaleBlue,
//                                       leadingIcon: Image.asset(
//                                         'assets/icons/icon_light_bulb.png',
//                                         color: buttonPaleBlue,
//                                         width: 13,
//                                         height: 13,
//                                       ),
//                                       // TODO: - カテゴリ管理がバックエンド側になったらdoctorTypeを消すので差し替える
//                                       title: viewModel
//                                           .currentChatThread
//                                           ?.category.doctorType
//                                           .indexUploaderName ??
//                                           '',
//                                       onTap: () {
//                                         showIndexAddDialog(
//                                             context,
//                                             viewModel,
//                                             IndexRegistrationTransitionType
//                                                 .fromChatPage, (type) {
//                                           // 安江さんが喋る
//                                           viewModel.addMessage(types.TextMessage(
//                                               author: ChatUser.chatBot,
//                                               id: ChatPageUtil.randomString(),
//                                               text:
//                                               '学習しました！\f教えていただきありがとうございます！\fまた色んな情報を教えてくださいね！'));
//                                         });
//                                       }),
//                                 ),
//                               ),
//
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 16, right: 16),
//                                 child: Container(
//                                     decoration: BoxDecoration(
//                                       border:
//                                       Border.all(color: Colors.black54),
//                                       borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(10)),
//                                       color: Colors.black.withOpacity(0.16),
//                                     ),
//                                     height:
//                                     viewModelState.isExpandedChatListView
//                                         ? expandedChatPageHeight
//                                         : defaultChatPageHeight,
//                                     width: screenSize.width,
//                                     child: Stack(
//                                       clipBehavior: Clip.none,
//                                       children: [
//                                         /// 人物名の表示
//                                         Positioned(
//                                           top: -32,
//                                           left: -1,
//                                           child: Container(
//                                               decoration: const BoxDecoration(
//                                                 borderRadius:
//                                                 BorderRadius.only(
//                                                     topLeft:
//                                                     Radius.circular(
//                                                         10),
//                                                     topRight:
//                                                     Radius.circular(
//                                                         30)),
//                                                 color: Color.fromRGBO(
//                                                     92, 97, 106, 1),
//                                               ),
//                                               height: 32,
//                                               child: Padding(
//                                                 padding:
//                                                 const EdgeInsets.only(
//                                                     top: 10,
//                                                     left: 16,
//                                                     right: 28,
//                                                     bottom: 0),
//                                                 child: Text(
//                                                   // TODO: - AI Toolsの方がインサイトくんUIじゃなくなったら分岐が不要になるので消す
//                                                   (ref.read(sideMenuViewModel).value?.selectedSideMenuTabType == SideMenuTabType.organizationInformation) ? (viewModel.currentChatThread
//                                                       ?.category)?.personName ?? '' : 'インサイトくん',
//                                                   style: const TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight:
//                                                     FontWeight.w700,
//                                                     fontSize: 12,
//                                                     height: 1.2,
//                                                   ),
//                                                 ),
//                                               )),
//                                         ),
//
//                                         // 擦りガラス風エフェクト部分
//                                         Positioned(
//                                           child: ClipRRect(
//                                             borderRadius:
//                                             const BorderRadius.only(
//                                                 topRight:
//                                                 Radius.circular(10)),
//                                             child: BackdropFilter(
//                                               filter: ImageFilter.blur(
//                                                   sigmaX: 10, sigmaY: 10),
//                                               child: Container(
//                                                 // color: Colors.black.withOpacity(0),
//                                                 decoration:
//                                                 const BoxDecoration(
//                                                   // color: Colors.black.withOpacity(0.3),
//                                                     color: Color.fromRGBO(
//                                                         209,
//                                                         209,
//                                                         209,
//                                                         0.3)),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                         ChatListView(
//                                             width: ResponsiveWidget
//                                                 .isSmallScreen(context)
//                                                 ? screenSize.width
//                                                 : screenSize.width -
//                                                 largeWidth,
//                                             user: ChatUser.user,
//                                             messages: viewModelState.messages,
//                                             currentChatThread:
//                                             viewModel.currentChatThread,
//                                             isShowLoadingForStream: viewModelState
//                                                 .isShowLoadingForStream,
//                                             onTapExpandChatAreaButton: viewModel
//                                                 .onTapExpandChatListViewButton,
//                                             onTapSendButton:
//                                             viewModel.onTapSendButton,
//                                             onTapNewChatButton:
//                                             viewModel.onTapNewChatButton,
//                                             onTapFeedbackButton:
//                                                 (message, goodOrBad) {
//
//                                             }),
//                                       ],
//                                     )),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ))
//               ],
//             )));
//   }
// }

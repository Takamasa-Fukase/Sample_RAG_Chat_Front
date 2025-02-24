import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_rag_chat/constants/custom_colors.dart';
import 'package:sample_rag_chat/presentation/chat/chat_view_model.dart';
import '../../constants/chat_page_const.dart';
import '../../constants/chat_user.dart';
import '../../utilities/error_handler.dart';
import '../common/custom_app_bar_for_large_screen.dart';
import '../common/custom_app_bar_for_small_screen.dart';
import '../common/responsive_widget.dart';
import '../side_menu/side_menu.dart';
import 'components/chat_list_view.dart';

class ChatView extends ConsumerStatefulWidget {
  ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<Exception> _errorSubscription;

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(chatViewModel);
    final debounce = ref.read(debounceProvider.notifier);

    viewModel.onViewInitState();

    /// MARK: - ViewModelからのイベントを購読して処理を行う
    _errorSubscription = viewModel.errorStream.listen((event) {
      debounce.debounce(const Duration(milliseconds: 500), () {
        ErrorHandler.handleException(context, event);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _errorSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(chatViewModel);
    final screenSize = MediaQuery.of(context).size;
    final double chatPageHeight = screenSize.height;
    final double defaultChatPageHeight = chatPageHeight * 0.5;

    /// ChatPageのメインコンテンツの描画処理
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? customAppBarForSmallScreen(
              leadingWidget: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: _scaffoldStateKey.currentState?.openDrawer),
              onTapUserIconButton: () {})
          : customAppBarForLargeScreen(
              screenSize: screenSize, onTapUserIconButton: () {}),
      drawer: ResponsiveWidget.isSmallScreen(context)

          /// カテゴリリスト（小サイズの時はドロワー内に表示する）
          ? Drawer(
              backgroundColor: Colors.transparent,
              width: ChatPageConst.sideMenuWidth,
              child: Container(
                padding: MediaQuery.of(context).size.width < 391
                    ? const EdgeInsets.only(right: 32, top: 8)
                    : const EdgeInsets.only(top: 8),
                child: SizedBox(
                    width: ChatPageConst.sideMenuWidth,
                    child: SideMenu(
                      onItemSelected: (index) {},
                    )),
              ))
          : null,
      body: Stack(
        children: [
          Container(
            color: CustomColor.goldLeaf,
          ),
          Row(children: [
            /// カテゴリリスト（中サイズ以上の画面の時は常時表示する）
            Visibility(
              visible: !ResponsiveWidget.isSmallScreen(context),
              child: SizedBox(
                width:
                    min(screenSize.width * 0.35, ChatPageConst.sideMenuWidth),
                child: SideMenu(
                  onItemSelected: (index) {},
                ),
              ),
            ),

            /// チャット画面部分
            Expanded(
                child: Stack(
              children: [
                // 背景画像
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background_image_barcelona.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(
                //   // color: Colors.white.withOpacity(0.1),
                //   color: CustomColor.goldLeaf.withOpacity(0.6),
                // ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                ),

                /// 人物画像
                Positioned(
                  top: screenSize.height * 0.02,
                  // bottom: 400,
                  bottom: defaultChatPageHeight + 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'images/fukase_thumb_up_1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// チャットの窓部分
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      // 領域確保用の透明なやつ
                      SizedBox(
                        height: defaultChatPageHeight + 36,
                        width: screenSize.width,
                      ),

                      Padding(
                        // padding: const EdgeInsets.only(left: 16, right: 16),
                        padding: (){
                          final chatAreaWidth = screenSize.width - ChatPageConst.sideMenuWidth;
                          if (ResponsiveWidget.isLargeScreen(context)) {
                            return EdgeInsets.only(
                              left: chatAreaWidth * 0.1,
                              right: chatAreaWidth * 0.1,
                            );
                          } else {
                            return EdgeInsets.only(
                              left: 16,
                              right: 16,
                            );
                          }
                        }(),
                        // padding: const EdgeInsets.only(
                        //   left: 116,
                        //   right: 116,
                        // ),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                color: CustomColor.paper,
                                width: 2,
                              ),
                              // color: CustomColor.customLightBrown.withOpacity(0.8),
                              color: CustomColor.customLightBrown.withOpacity(
                                  0.9), // こっちの方がメリハリがつく気がする。印象がぼやけない。
                            ),
                            height: defaultChatPageHeight,
                            width: screenSize.width,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                /// 人物名の表示
                                Positioned(
                                  top: -36,
                                  left: -2,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(30)),
                                        border: Border.all(
                                          color: CustomColor.paper,
                                          width: 2,
                                        ),
                                        color: CustomColor.customLightBrown,
                                      ),
                                      height: 36,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            left: 16,
                                            right: 28,
                                            bottom: 0),
                                        child: Text(
                                          'UltraFukase',
                                          style: const TextStyle(
                                            color: CustomColor.paper,
                                            fontFamily: 'Copperplate-Heavy',
                                            fontSize: 12,
                                            height: 1.2,
                                          ),
                                        ),
                                      )),
                                ),

                                // 擦りガラス風エフェクト部分
                                // Positioned(
                                //   child: ClipRRect(
                                //     borderRadius: const BorderRadius
                                //         .only(
                                //         topRight: Radius.circular(10)),
                                //     child: BackdropFilter(
                                //       filter: ImageFilter.blur(
                                //           sigmaX: 10, sigmaY: 10),
                                //       child: Container(
                                //         // color: Colors.black.withOpacity(0),
                                //         decoration: const BoxDecoration(
                                //           // color: Colors.black.withOpacity(0.3),
                                //             color: Color.fromRGBO(
                                //                 209, 209, 209, 0.3)),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                ChatListView(
                                  messages: viewModel.messages,
                                  currentChatThread:
                                      viewModel.currentChatThread,
                                  isShowLoadingForStream:
                                      viewModel.isShowLoadingForStream,
                                  onTapSendButton: viewModel.onTapSendButton,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ))
          ]),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../common/responsive_widget.dart';
import '../../constants/chat_page_const.dart';
import '../../constants/custom_colors.dart';

class AgentActionInfoBubble extends StatelessWidget {
  const AgentActionInfoBubble({required this.textMessage, Key? key})
      : super(key: key);

  final types.TextMessage textMessage;

  @override
  Widget build(BuildContext context) {
    final sideMenuWidth = (ResponsiveWidget.isSmallScreen(context))
        ? 0
        : ChatPageConst.sideMenuWidth;
    final chatWindowWidth = MediaQuery
        .of(context)
        .size
        .width - sideMenuWidth;
    // chatVMでmessage配列に追加する時にtextMessageのメタデータに仕込んだprogressの値を取り出す
    final int? progress = textMessage.metadata?['progress'];
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        child: Container(
            decoration: BoxDecoration(
              color: CustomColor.customDarkBrown,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: CustomColor.paper, width: 2),
            ),
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: chatWindowWidth * 0.82),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (progress == 100)
                    // progressが100（完了）ならチェックマークアイコンを渡す
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.check, size: 20, color: CustomColor.paper),
                      )
                    else
                    // progressが100以外（処理中）なら丸型インジケータを渡す
                    //  - nullの場合: ただクルクルさせておく（GPTからの検索クエリのStream出力は処理中かそれ以外かしか取れないのでこちらにしている）
                    //  - 0~99の場合: 割合に応じて進捗表示する（スクレイピング周りの非同期処理は進捗取得イベントを自作したのでこちらにしている）
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 12),
                        child: CircularProgressIndicator(
                          // 0.0 ~ 1.0の値に変換する（nullの場合はnullのままにする）
                          value: (progress != null) ? (progress / 100) : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColor.paper.withOpacity(0.8)),
                          color: CustomColor.paper,
                          backgroundColor: CustomColor.blackSteel,
                        ),
                      ),

                    Flexible(
                      child: Text(
                        textMessage.text,
                        style: const TextStyle(fontSize: 10, color: CustomColor.paper),
                      ),
                    ),
                  ],
                ))));
  }
}

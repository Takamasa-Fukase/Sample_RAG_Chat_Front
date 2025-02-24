import 'package:flutter/material.dart';
import 'package:sample_rag_chat/constants/custom_colors.dart';
import '../common/responsive_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.onItemSelected,
  });

  final Function(int) onItemSelected;

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  final categoryNames = [
    'Fukase in \nNagano, 2019',
    'Taka in Barcelona, 2022',
    'UltraFukase in Tokyo, 2023',
    'UltraFukase in India, 2024',
    'UltraFukase in Tokyo, 2025',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 0),
                      itemCount: categoryNames.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final categoryName = categoryNames[index];
                        return listItem(
                            title: categoryName,
                            onTap: () {
                              widget.onItemSelected(index);

                              // 小画面の時はこの画面がドロワーとして扱われているのでpop
                              if (ResponsiveWidget.isSmallScreen(context)) {
                                Navigator.of(context).pop();
                              }
                            });
                      },
                    ),
                  ],
                ),
              ),

              // 下の余白
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem({required String title, required Function() onTap}) {
    return Container(
      color: CustomColor.goldLeaf,
      // decoration: BoxDecoration(
      //   color: CustomColor.paper,
      //   borderRadius: BorderRadius.all(Radius.circular(30)),
      //   border: Border.all(
      //     color: CustomColor.blackSteel,
      //     width: 2,
      //   ),
      // ),
      // カード自体を浮いて見せる為のマージン
      // margin: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
      height: 100,
      child: Material(
        color: Colors.transparent,
        // タップ時のエフェクトの為にInkwellを使用
        child: InkWell(
          onTap: onTap,
          // ハイライト色
          // highlightColor: CustomColor.blackSteel.withOpacity(0.2),
          // タップ箇所から広がる波紋の色
          splashColor: Colors.transparent,
          // エフェクト領域にもカードと同じ角丸を適用
          // borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Container(
            // カードの内側の余白
            padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
            child: Text(
              title,
              style: TextStyle(
                  color: CustomColor.blackSteel,
                  fontSize: 16,
                  fontFamily: 'Copperplate-Heavy'),
            ),
          ),
        ),
      ),
    );
  }
}

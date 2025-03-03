import 'package:flutter/material.dart';
import 'package:sample_rag_chat/constants/custom_colors.dart';
import '../../data_models/category/category.dart';
import '../common/responsive_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onItemSelected,
  });

  final List<Category> categories;
  final int selectedCategoryIndex;
  final Function(int) onItemSelected;

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                      itemCount: widget.categories.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final category = widget.categories[index];
                        return listItem(
                            title: category.name,
                            isSelected: index == widget.selectedCategoryIndex,
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
              SizedBox(
                // height: 200,
                height: screenSize.height - (100 * widget.categories.length),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem({required String title, required bool isSelected, required Function() onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        child: Container(
          // カードの内側の余白
          height: 100,
          padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                color: (isSelected) ? CustomColor.blackSteel : CustomColor.blackSteel.withOpacity(0.7),
                // size: 12,
                size: (isSelected) ? 12 : 8,
              ),

              SizedBox(width: 8,),

              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: (isSelected) ? CustomColor.blackSteel : CustomColor.blackSteel.withOpacity(0.8),
                    // fontSize: 16,
                    fontSize: (isSelected) ? 14 : 12,
                    fontFamily: 'Copperplate-Heavy',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

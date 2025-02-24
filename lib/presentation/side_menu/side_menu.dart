import 'package:flutter/material.dart';
import '../common/responsive_widget.dart';
import 'components/genre_list.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.onItemSelected,});

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
    return SingleChildScrollView(
      child: Column(
        children: [
          GenreList(
            onListTapped: (index) {
              widget.onItemSelected(index);

              // 小画面の時はこの画面がドロワーとして扱われているのでpop
              if (ResponsiveWidget.isSmallScreen(context)) {
                Navigator.of(context).pop();
              }
            },
          ),

          // 下の余白
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

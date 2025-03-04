import 'package:flutter/material.dart';

import '../constants/custom_colors.dart';

/// 上部のアプリバータイトル部（小さいサイズ）
AppBar customAppBarForSmallScreen({
  Widget? leadingWidget,
  required Function() onTapUserIconButton,
}) {
  return AppBar(
    title: Container(
      margin: const EdgeInsets.only(top: 7, bottom: 7, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Talk with',
            style: TextStyle(
              fontSize: 11,
              color: CustomColor.blackSteel,
              fontFamily: 'Copperplate-Heavy',
            ),
          ),
          const Text(
            "ULTRA FUKASE's History",
            style: TextStyle(
              fontSize: 13,
              color: CustomColor.blackSteel,
              fontFamily: 'Copperplate-Heavy',
            ),
          ),
        ],
      ),
    ),
    centerTitle: true,
    backgroundColor: CustomColor.goldLeaf,
    shadowColor: Colors.black.withOpacity(0.5),
    leading: leadingWidget,
    actions: <Widget>[
    ],
  );
}

import 'package:flutter/material.dart';

import '../../constants/custom_colors.dart';

/// 上部のアプリバータイトル部（小さいサイズ）
AppBar customAppBarForSmallScreen({
  Widget? leadingWidget,
  required Function() onTapUserIconButton,
}) {
  return AppBar(
    title: Container(
      margin: const EdgeInsets.only(top: 7, bottom: 7, left: 12),
      child: const Text('ULTRA FUKASE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColor.blackSteel),),
    ),
    centerTitle: true,
    backgroundColor: CustomColor.goldLeaf,
    shadowColor: Colors.black.withOpacity(0.5),
    leading: leadingWidget,
    actions: <Widget>[
    ],
  );
}

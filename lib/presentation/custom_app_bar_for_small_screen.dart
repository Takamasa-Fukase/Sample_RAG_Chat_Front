import 'package:flutter/material.dart';

/// 上部のアプリバータイトル部（小さいサイズ）
AppBar customAppBarForSmallScreen({
  Widget? leadingWidget,
  required Function() onTapUserIconButton,
}) {
  return AppBar(
    title: SizedBox(
      height: 30,
      child: Image.asset('assets/aig_hedder_logo.png'),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.5),
    leading: leadingWidget,
    actions: <Widget>[
    ],
  );
}

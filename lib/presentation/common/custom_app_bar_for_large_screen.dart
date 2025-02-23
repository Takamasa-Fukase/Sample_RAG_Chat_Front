import 'package:flutter/material.dart';

import '../../constants/custom_colors.dart';

/// 上部のアプリバータイトル部（大きいサイズ）
PreferredSize customAppBarForLargeScreen({
  required Size screenSize,
  required Function() onTapUserIconButton,
}) {
  return PreferredSize(
    preferredSize: Size(screenSize.width, 1000),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     offset: const Offset(0, 2),
        //     blurRadius: 1.0,
        //   ),
        // ],
        color: CustomColor.goldLeaf,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7, bottom: 7, left: 12),
                child: const Text('ULTRA FUKASE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColor.blackSteel),),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

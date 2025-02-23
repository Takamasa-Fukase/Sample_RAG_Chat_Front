// import 'package:arsaga_company_gpt_app/widget/components/common/custom_user_icon_button.dart';
// import 'package:flutter/material.dart';
//
// /// 上部のアプリバータイトル部（大きいサイズ）
// PreferredSize customAppBarForLargeScreen({
//   required Size screenSize,
//   required Function() onTapUserIconButton,
// }) {
//   return PreferredSize(
//     preferredSize: Size(screenSize.width, 1000),
//     child: Container(
//       height: 50,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             offset: const Offset(0, 2),
//             blurRadius: 1.0,
//           ),
//         ],
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 7, bottom: 7, left: 12),
//                 child: const Image(
//                   image: AssetImage('assets/aig_hedder_logo.png'),
//                 ),
//               ),
//             ],
//           ),
//           CustomUserIconButton(
//             size: 32,
//             onTap: onTapUserIconButton,
//           ),
//         ],
//       ),
//     ),
//   );
// }

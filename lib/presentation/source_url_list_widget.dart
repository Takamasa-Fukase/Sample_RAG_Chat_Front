// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import '../../../utility/url_launcher_util.dart';
//
// class SourceUrlListWidget extends StatelessWidget {
//   const SourceUrlListWidget({
//     required this.urlList,
//     Key? key,
//   }) : super(key: key);
//
//   final List<String> urlList;
//
//   @override
//   Widget build(BuildContext context) {
//     // FIXME: - （もっと良い書き方知ってたら教えてください。急ぎ実装でFlutterの参照渡し対策をしてます）引数で受け取ったurlListに直接insertすると参照渡しになっていて大元の変数が書き変わってしまうため、一度addAllで中身だけ受け渡して参照を断ち切っている
//     List<String> copiedUrlList = [];
//     // MEMO: - ソースURL表示で、空白の数字が無限に増えていくバグの原因はここの参照渡しで、大元の変数（twoDigitsSourceURLList.last）に無限にinsertされて行っていたからだった。一旦、addAllで中身だけ入れ替えて直した。
//     copiedUrlList.addAll(urlList);
//     if (copiedUrlList.isNotEmpty) {
//       // 「詳細資料 :」 部分を同じWrapに差し込むため、indexを調整するためのダミーの値を入れる。改行された場合に良い感じに表示したいから一緒にWrapに入れている。
//       copiedUrlList.insert(0, '');
//     }
//     return Container(
//       padding: const EdgeInsets.only(top: 0, left: 0, bottom: 12, right: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Divider(
//             height: 0,
//             thickness: 1,
//             color: Color.fromRGBO(209, 209, 209, 1),
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 16, right: 16),
//             child: Wrap(
//               direction: Axis.horizontal,
//               crossAxisAlignment: WrapCrossAlignment.center,
//               spacing: 8,
//               runSpacing: 12,
//               children: copiedUrlList.mapIndexed((index, url) {
//                 if (index == 0) {
//                   return const Text(
//                     '詳細資料 :',
//                     style: TextStyle(
//                       color: Color.fromRGBO(92, 97, 106, 1),
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                     ),
//                   );
//                 }
//                 final urlDomain = Uri.parse(url).host;
//                 return TextButton(
//                   onPressed: () {
//                     // LaunchURL時は部分はドメイン部分ではなくそのままのURLを使う
//                     UrlLauncherUtil.launchURL(url);
//                   },
//                   style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: const Size(50, 30),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       alignment: Alignment.centerLeft),
//                   child: FittedBox(
//                     fit: BoxFit.fill,
//                     child: Container(
//                       height: 28,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           color: const Color.fromRGBO(232, 238, 252, 1)),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           top: 4.0,
//                           right: 8.0,
//                           left: 8.0,
//                           bottom: 4.0,
//                         ),
//                         child: Center(
//                           child: Text(
//                             // index番号と、ドメイン部分を表示
//                             '${(index)}. $urlDomain',
//                             style: const TextStyle(
//                               color: Color.fromRGBO(72, 113, 239, 1),
//                               fontWeight: FontWeight.w700,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

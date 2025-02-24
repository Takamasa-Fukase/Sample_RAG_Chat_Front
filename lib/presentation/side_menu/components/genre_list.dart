import 'package:flutter/material.dart';

class GenreList extends StatefulWidget {
  const GenreList({super.key, required this.onListTapped});

  final Function(int index) onListTapped;

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  @override
  void initState() {
    super.initState();
    // ここで後でジャンルリストをサーバーから取得に変える
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 0),
              itemCount: 5,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 0),
                          child: Text(
                            'UltraFukase en Espana',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          // タップされたindexを受け渡し
                          widget.onListTapped(index);
                        }),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                );
              })
        ],
      ),
    ));
  }
}

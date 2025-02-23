import 'package:flutter/material.dart';

// TODO: - messageが空文字の場合変な余白ができちゃってるので、nullableにしてnullの時はmessage部分のTextWidgetをトルツメした方が良い
void showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(top: 0, right: 7, bottom: 7),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              padding: const EdgeInsets.all(19),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '閉じる',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
    ),
  );
}

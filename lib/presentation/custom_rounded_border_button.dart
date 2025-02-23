import 'package:flutter/material.dart';

class CustomRoundedBorderIconButton extends StatelessWidget {
  const CustomRoundedBorderIconButton({
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.borderColor = Colors.black,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Widget leadingIcon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 32,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              side: BorderSide(
                color: borderColor,
                width: 1,
              )),
          onPressed: onTap,
          icon: leadingIcon,
          label: Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ));
  }
}

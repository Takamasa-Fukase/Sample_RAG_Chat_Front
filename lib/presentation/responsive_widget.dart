import 'package:flutter/material.dart';

enum ScreenScaleType {
  large,
  medium,
  small,
}

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget(
      {Key? key,
        required this.largeScreen,
        this.mediumScreen,
        this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  static ScreenScaleType scaleType(BuildContext context) {
    if (isLargeScreen(context)) {
      return ScreenScaleType.large;
    }else if (isMediumScreen(context)) {
      return ScreenScaleType.medium;
    }else {
      return ScreenScaleType.small;
    }
  }

  static Widget horizontalSpacer(BuildContext context, {required double large, required double medium, required double small}) {
    return SizedBox(width: (() {
      switch (scaleType(context)) {
        case ScreenScaleType.large:
          return large;
        case ScreenScaleType.medium:
          return medium;
        case ScreenScaleType.small:
          return small;
      }
    })());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}

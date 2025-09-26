import 'package:flutter/material.dart';
import 'package:elite/constant/app_colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
    scaffoldBackgroundColor: AppColor.blackColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.blackColor,
    ),
  );
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: child,
    );
  }
}

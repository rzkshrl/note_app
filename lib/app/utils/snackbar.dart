import 'package:flutter/material.dart';

class SnackBarService {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  static void showSnackBar(
      {Key? key,
      required Widget content,
      Color? backgroundColor,
      double? elevation,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding,
      double? width,
      ShapeBorder? shape,
      SnackBarBehavior? behavior,
      SnackBarAction? action,
      Duration? duration,
      Animation<double>? animation,
      VoidCallback? onVisible}) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: content));
  }
}

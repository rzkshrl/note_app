import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void routeTo(String route, {dynamic arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(route, arguments: arguments);
    }
  }

  void goBack() {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pop();
    }
  }
}

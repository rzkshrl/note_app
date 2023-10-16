import 'package:flutter/material.dart';
import 'package:note_app/app/components/home.dart';
import 'package:note_app/app/components/text_editor.dart';

import 'routing_constant.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // handle all routing in app
    switch (settings.name) {
      case homeViewRoute:
        return MaterialPageRoute(builder: (context) => const Home());
      case textEditorViewRoute:
        return MaterialPageRoute(builder: (context) => const TextEditor());
      default:
        return MaterialPageRoute(builder: (context) => const Home());
    }
  }
}

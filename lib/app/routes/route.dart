import 'package:flutter/material.dart';
import 'package:note_app/app/components/favorites.dart';
import 'package:note_app/app/components/home.dart';
import 'package:note_app/app/components/text_editor.dart';

import 'routing_constant.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // handle all routing in app
    switch (settings.name) {
      case homeViewRoute:
        return MaterialPageRoute(
            builder: (context) => const Home(), settings: settings);
      case textEditorNewViewRoute:
        return MaterialPageRoute(
            builder: (context) => TextEditor(args: ['new', settings.arguments]),
            settings: settings);
      case textEditorUpdateViewRoute:
        return MaterialPageRoute(
            builder: (context) =>
                TextEditor(args: ['update', settings.arguments]),
            settings: settings);
      case favoritesViewRoute:
        return MaterialPageRoute(
            builder: (context) => const Favorites(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => const Home(), settings: settings);
    }
  }
}

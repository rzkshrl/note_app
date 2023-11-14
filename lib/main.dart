import 'package:flutter/material.dart';
import 'package:note_app/app/routes/navigation_service.dart';
import 'package:note_app/app/routes/routing_constant.dart';
import 'package:note_app/app/theme/theme.dart';
import 'package:note_app/app/utils/snackbar.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting().then((_) => runApp(const NoteApp()));
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      NavigationService navService = NavigationService();
      return MaterialApp(
        title: 'Notepad',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: SnackBarService.scaffoldKey,
        themeMode: ThemeMode.system,
        theme: NoteAppTheme.lightTheme,
        darkTheme: NoteAppTheme.darkTheme,
        localeResolutionCallback: (locale, supportedLocales) {
          return locale;
        },
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('id', 'ID'),
        ],
        navigatorKey: navService.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: homeViewRoute,
      );
    });
  }
}

class CustomPageRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  CustomPageRouteBuilder(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}

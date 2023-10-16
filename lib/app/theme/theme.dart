import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

Color light = HexColor('#FFFFFF');
Color light2 = HexColor('#f2f3f5');
Color dark = HexColor('#000000');
Color blue = HexColor('#2f79f6');
Color grey = HexColor('#656565');
Color greyDark = HexColor('#1a1a1a');
Color greyDark2 = HexColor('#1f2326');
Color red = HexColor('#c04c4c');

class NoteAppTheme {
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: dark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: dark,
      iconTheme: IconThemeData(color: light),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: dark,
      ),
    ),
    iconTheme: IconThemeData(
      color: light,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: blue,
      foregroundColor: light,
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Colors.transparent),
    popupMenuTheme: PopupMenuThemeData(
      color: greyDark2,
      surfaceTintColor: Colors.transparent,
      textStyle:
          TextStyle(color: light, fontSize: 10.sp, fontWeight: FontWeight.w400),
    ),
    cardColor: greyDark,
    canvasColor: greyDark2,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: blue,
      selectionColor: blue.withOpacity(0.5),
      selectionHandleColor: blue.withOpacity(0.8),
    ),
    brightness: Brightness.dark,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: light,
        fontSize: 16.sp,
      ),
      headlineMedium: TextStyle(
        color: light,
        fontSize: 14.sp,
      ),
      headlineSmall: TextStyle(
        color: light,
        fontSize: 12.sp,
      ),
      displayLarge: TextStyle(
        color: grey,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        color: light.withOpacity(0.4),
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      displaySmall: TextStyle(
        color: greyDark,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(
        color: light.withOpacity(0.7),
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: blue,
        fontSize: 10.sp,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: light2,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: light,
      iconTheme: IconThemeData(color: dark),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: light2,
      ),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Colors.transparent),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: blue,
      foregroundColor: light,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: blue,
      selectionColor: blue.withOpacity(0.5),
      selectionHandleColor: blue.withOpacity(0.8),
    ),
    brightness: Brightness.light,
    popupMenuTheme: PopupMenuThemeData(
      color: light,
      surfaceTintColor: Colors.transparent,
      textStyle:
          TextStyle(color: dark, fontSize: 10.sp, fontWeight: FontWeight.w400),
    ),
    iconTheme: IconThemeData(
      color: dark,
    ),
    cardColor: light,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: dark,
        fontSize: 16.sp,
      ),
      headlineMedium: TextStyle(
        color: dark,
        fontSize: 14.sp,
      ),
      headlineSmall: TextStyle(
        color: dark,
        fontSize: 12.sp,
      ),
      displayLarge: TextStyle(
        color: grey,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        color: greyDark,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: dark.withOpacity(0.7),
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        color: blue,
        fontSize: 10.sp,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

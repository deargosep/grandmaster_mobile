import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    dividerColor: Color(0xFFF3F3F3),
    dividerTheme: DividerThemeData(thickness: 2),
    fontFamily: 'TTNormsPro',
    primaryColor: Color(0xFFFF5858),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Color(0xFFFF5858)),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFFBF7F7),
      prefixStyle: TextStyle(
          color: Color(0xFF927474), fontSize: 14, fontWeight: FontWeight.w500),
      labelStyle: TextStyle(
          color: Color(0xFFE1D6D6), fontSize: 14, fontWeight: FontWeight.w500),
    ),
    // appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Color(0xFF4F3333), secondaryContainer: Color(0xFF927474)),
    // cardColor: Color(0xFFE4F3F7),
    // textTheme: TextTheme(caption: TextStyle(color: Colors.white)),
    // primaryIconTheme: IconThemeData(color: Colors.black, size: 24),
    // primaryColorDark: Colors.white,
    // colorScheme: ColorScheme.light(),
    // shadowColor: Color(0xFF54B2CF),
    // buttonColor: Color(0xFF323232),
    // appBarTheme: AppBarTheme(
    //     backgroundColor: Colors.white,
    //     systemOverlayStyle: SystemUiOverlayStyle.light)
  );

  static ThemeData darkTheme = ThemeData(
      // fontFamily: 'Readex',
      // scaffoldBackgroundColor: Color(0xFF1F1D2B),
      // cardColor: Color(0xFF262836),
      // colorScheme: ColorScheme.dark(),
      // shadowColor: Color(0xFF4795AD),
      // buttonColor: Color(0xFF4795AD),
      // textTheme: TextTheme(caption: TextStyle(color: Colors.black)),
      // primaryIconTheme: IconThemeData(color: Colors.white),
      // primaryColorDark: Color(0xFF1F1D2B),
      // appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.black,
      //     systemOverlayStyle: SystemUiOverlayStyle.dark)
      );
}

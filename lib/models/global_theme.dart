import 'package:copy_todo_mvc/models/app_color.dart';
import 'package:flutter/material.dart';

class GlobalTheme {
  GlobalTheme._();
  
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(245, 255, 255, 255)),
      fontFamily: "Helvetica Neue",
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              backgroundColor: null,
              wordSpacing: 1,
              decorationThickness: 1,
            ),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColor.titleRed,
          fontWeight: FontWeight.w200,
          fontSize: 48,
        ),
        displaySmall: TextStyle(
          color: AppColor.titleRed,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        bodySmall: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        labelSmall: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w200,
          fontSize: 16,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(1, 13, 15, 37),
          brightness: Brightness.dark),
      disabledColor: Colors.white10,
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              backgroundColor: null,
              wordSpacing: 1,
              decorationThickness: 1,
            ),
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColor.titleRed,
          fontWeight: FontWeight.w200,
          fontSize: 48,
        ),
        displaySmall: TextStyle(
          color: AppColor.titleRed,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        bodySmall: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        labelSmall: TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.w200,
          fontSize: 16,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData light(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(245, 255, 255, 255)),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: "Helvetica Neue",
              backgroundColor: null,
              wordSpacing: 1,
              decorationThickness: 1,
            )
          )
        )
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
          fontSize: 24,
          fontFamily: "Helvetica Neue"
        )
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Color(0xffb83f45),
          fontWeight: FontWeight.w200,
          fontSize: 48,
          fontFamily: "Helvetica Neue"
        ),
        displaySmall: TextStyle(
          color: Color(0xffb83f45),
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: "Helvetica Neue"
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: "Helvetica Neue"
        ),
        bodySmall: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        ),
        labelSmall: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w200,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        ), 
      )
    );
  }

  static ThemeData dark(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 13, 15, 37), brightness: Brightness.dark),
      disabledColor: Colors.white10,
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: "Helvetica Neue",
              backgroundColor: null,
              wordSpacing: 1,
              decorationThickness: 1,
            )
          )
        )
      ),
      listTileTheme: const ListTileThemeData(
        titleTextStyle: TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w400,
          fontSize: 24,
          fontFamily: "Helvetica Neue"
        )
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Color(0xffb83f45),
          fontWeight: FontWeight.w200,
          fontSize: 48,
          fontFamily: "Helvetica Neue"
        ),
        displaySmall: TextStyle(
          color: Color(0xffb83f45),
          fontWeight: FontWeight.w400,
          fontSize: 20,
          fontFamily: "Helvetica Neue"
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: "Helvetica Neue"
        ),
        bodySmall: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        ),
        labelSmall: TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.w200,
          fontSize: 16,
          fontFamily: "Helvetica Neue"
        )
      )
    );
  }
}
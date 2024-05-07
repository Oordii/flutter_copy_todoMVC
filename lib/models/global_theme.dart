
import 'package:flutter/material.dart';

class GlobalTheme {
  static ThemeData light(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(245, 255, 255, 255))
    );
  }

  static ThemeData dark(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 13, 15, 37), brightness: Brightness.dark)
    );
  }
}
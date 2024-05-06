
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsService {
  SettingsService();

  final box = Hive.box('settings');

  Future<void> setTheme(ThemeMode mode) async {
    await box.put('isDarkMode', mode == ThemeMode.dark ? true : false);
  }

  Future<ThemeMode> getTheme() async {
    var isDarkMode = await box.get('isDarkMode');

    if (isDarkMode == null){
      isDarkMode = ThemeMode.system == ThemeMode.dark ? true : false;
      await box.put('isDarkMode', isDarkMode);
    }
    
    return  isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
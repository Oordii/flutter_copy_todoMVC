
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';
import 'package:flutter/material.dart';

class SettingsService {
  final Repository _repository;
  SettingsService() : _repository = getIt.get<Repository>();

  Future<void> setTheme(ThemeMode mode) async {
    await _repository.setTheme(mode);
  }

  Future<ThemeMode> getTheme() async {
    return await _repository.getTheme();
  }
}
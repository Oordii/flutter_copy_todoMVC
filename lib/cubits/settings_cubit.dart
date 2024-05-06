import 'package:copy_todo_mvc/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _settingsService = SettingsService();
  
  SettingsCubit() : super(SettingsState(themeMode: ThemeMode.system)) {
    _initializeSettings();
  }

  _initializeSettings() async {
    emit(SettingsState(themeMode: await _settingsService.getTheme()));
  }

  void setTheme(ThemeMode mode) async {
    await _settingsService.setTheme(mode);
    emit(SettingsState(themeMode: await _settingsService.getTheme()));
  }
}
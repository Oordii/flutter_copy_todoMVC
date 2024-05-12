import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;
  SettingsCubit() : _settingsService = getIt.get<SettingsService>(), super(SettingsState());

  init() async {
    emit(SettingsState(themeMode: await _settingsService.getTheme()));
  }

  void setTheme(ThemeMode mode) async {
    await _settingsService.setTheme(mode);
    emit(SettingsState(themeMode: await _settingsService.getTheme()));
  }
}
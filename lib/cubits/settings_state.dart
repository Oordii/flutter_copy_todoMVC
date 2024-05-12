part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState{
  const SettingsState._();

  factory SettingsState({
    @Default(ThemeMode.system)
    ThemeMode themeMode
  }) = _SettingsState;
}
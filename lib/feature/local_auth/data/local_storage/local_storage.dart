import 'dart:convert';

import 'package:local_auth_showcase/feature/local_auth/data/dto/local_auth_settings_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalAuthSettingsStorage {
  /// Получить текущие настройки локальной аутентификации.
  LocalAuthSettingsDto? get localAuthSettings;

  /// Установить настройки локальной аутентификации.
  Future<void> editLocalAuthSettings(LocalAuthSettingsDto value);
}

abstract interface class LocalAuthBackgroundTimeStorage {
  /// Получить время перехода приложения в фон.
  String? get goToBackgroundTime;

  /// Установить время перехода приложения в фон.
  Future<void> setGoToBackgroundTime(DateTime time);
}

/// Локальное хранилище фичи "Защищенный вход".
class LocalAuthLocalStorageImpl
    implements LocalAuthSettingsStorage, LocalAuthBackgroundTimeStorage {
  const LocalAuthLocalStorageImpl(this._sharedPrefs);

  final SharedPreferences _sharedPrefs;

  static const _localAuthSettingsKey = 'LocalAuthStorage_localAuthSettingsKey';
  static const _backgroundTimeKey = 'LocalAuthStorage_backgroundTimeKey';

  @override
  LocalAuthSettingsDto? get localAuthSettings {
    final settings = _sharedPrefs.getString(_localAuthSettingsKey);

    if (settings == null) {
      return null;
    }

    return LocalAuthSettingsDto.fromJson(
      jsonDecode(settings) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> editLocalAuthSettings(LocalAuthSettingsDto value) async {
    final jsonString = jsonEncode(value.toJson());
    await _sharedPrefs.setString(_localAuthSettingsKey, jsonString);
  }

  @override
  String? get goToBackgroundTime {
    final data = _sharedPrefs.getString(_backgroundTimeKey);
    _sharedPrefs.remove(_backgroundTimeKey);

    return data;
  }

  @override
  Future<void> setGoToBackgroundTime(DateTime time) async =>
      _sharedPrefs.setString(_backgroundTimeKey, time.toIso8601String());
}

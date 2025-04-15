// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_auth_settings_dto.freezed.dart';
part 'local_auth_settings_dto.g.dart';

/// DTO для сохранения в локальной БД данных локальной аутентификации.
@freezed
sealed class LocalAuthSettingsDto with _$LocalAuthSettingsDto {
  /// Нет локальной аутентификации.
  factory LocalAuthSettingsDto.none() = _None;

  /// Установлена аутентификация по пин-коду.
  factory LocalAuthSettingsDto.pinCode(String hashedPinCode) = _PinCode;

  /// Установлена аутентификация по пин-коду и биометрии.
  factory LocalAuthSettingsDto.biometrics(String hashedPinCode) = _Biometrics;

  const LocalAuthSettingsDto._();

  factory LocalAuthSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$LocalAuthSettingsDtoFromJson(json);

  bool get noneLocalAuth => this is _None;

  bool get isPinCodeSet => switch (this) {
    _PinCode() => true,
    _Biometrics() => true,
    _ => false,
  };

  bool get isBiometricsOn => this is _Biometrics;

  String? get hashedPinCode => switch (this) {
    _PinCode(hashedPinCode: final hashedPinCode) => hashedPinCode,
    _Biometrics(hashedPinCode: final hashedPinCode) => hashedPinCode,
    _ => null,
  };
}

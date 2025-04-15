// Dart imports:
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:local_auth_showcase/core/extensions/string_extension.dart';
import 'package:local_auth_showcase/feature/local_auth/data/dto/local_auth_settings_dto.dart';
import 'package:local_auth_showcase/feature/local_auth/data/local_storage/local_storage.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/entity/pin_code.dart';

class LocalAuthRepositoryImpl implements LocalAuthRepository {
  const LocalAuthRepositoryImpl({
    required LocalAuthSettingsStorage settingsStorage,
    required LocalAuthBackgroundTimeStorage backgroundTimeStorage,
  }) : _settingsStorage = settingsStorage,
       _backgroundTimeStorage = backgroundTimeStorage;

  final LocalAuthSettingsStorage _settingsStorage;
  final LocalAuthBackgroundTimeStorage _backgroundTimeStorage;

  @override
  Future<bool> get isPinCodeSet async =>
      _settingsStorage.localAuthSettings?.isPinCodeSet ?? false;

  @override
  Future<void> savePinCode(PinCode input) async {
    final hashedPinCode = _hashPinCode(input);

    final updatedSettings =
        await isBiometricsOn
            ? LocalAuthSettingsDto.biometrics(hashedPinCode)
            : LocalAuthSettingsDto.pinCode(hashedPinCode);

    await _settingsStorage.editLocalAuthSettings(updatedSettings);
  }

  @override
  Future<bool> checkPinCode(PinCode input) async {
    final hashedPinCode = _settingsStorage.localAuthSettings?.hashedPinCode;
    if (hashedPinCode.isEmptyOrNull) {
      return false;
    }
    final inputHash = _hashPinCode(input);
    return hashedPinCode == inputHash;
  }

  @override
  Future<void> deletePinCodeAndDisableBiometrics() async =>
      _settingsStorage.editLocalAuthSettings(LocalAuthSettingsDto.none());

  @override
  Future<bool> get isBiometricsOn async =>
      _settingsStorage.localAuthSettings?.isBiometricsOn ?? false;

  @override
  Future<void> enableBiometricsForLogin() async {
    final settings = _settingsStorage.localAuthSettings;
    final hashedPinCode = settings?.hashedPinCode;
    if (hashedPinCode.isEmptyOrNull) {
      return;
    }

    final updatedSettings = LocalAuthSettingsDto.biometrics(hashedPinCode!);
    await _settingsStorage.editLocalAuthSettings(updatedSettings);
  }

  @override
  Future<void> disableBiometricsForLogin() async {
    final settings = _settingsStorage.localAuthSettings;
    final hashedPinCode = settings?.hashedPinCode;
    if (hashedPinCode.isEmptyOrNull) {
      return;
    }

    final updatedSettings = LocalAuthSettingsDto.pinCode(hashedPinCode!);
    await _settingsStorage.editLocalAuthSettings(updatedSettings);
  }

  @override
  Duration get appInBackgroundTime {
    final goToBackgroundTime = DateTime.tryParse(
      _backgroundTimeStorage.goToBackgroundTime ?? '',
    );

    if (goToBackgroundTime == null) {
      return Duration.zero;
    }

    final time = DateTime.now().difference(goToBackgroundTime);

    return time;
  }

  @override
  Future<void> setGoToBackgroundTime(DateTime time) async =>
      _backgroundTimeStorage.setGoToBackgroundTime(time);

  /// Хеширование пин-кода.
  String _hashPinCode(PinCode input) {
    final bytes = utf8.encode(input.value);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }
}

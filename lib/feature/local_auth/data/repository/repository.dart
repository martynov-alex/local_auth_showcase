import 'package:local_auth_showcase/feature/local_auth/domain/entity/pin_code.dart';

/// Интерфейс репозитория "Защищенного входа".
abstract interface class LocalAuthRepository {
  /// Установлен ли пин-код.
  Future<bool> get isPinCodeSet;

  /// Сохранить пин-код.
  Future<void> savePinCode(PinCode input);

  /// Сравнение введенного пин-кода с сохраненным.
  ///
  /// Возвращает true, если введенный и сохраненный пин-коды совпадают.
  Future<bool> checkPinCode(PinCode input);

  /// Удалить установленный пин-код и отключить биометрию.
  Future<void> deletePinCodeAndDisableBiometrics();

  /// Выбрал ли пользователь использовать биометрию для входа в приложение.
  Future<bool> get isBiometricsOn;

  /// Включить биометрию для входа в приложение.
  Future<void> enableBiometricsForLogin();

  /// Выключить биометрию для входа в приложение.
  Future<void> disableBiometricsForLogin();

  /// Сколько времени прошло с последнего перехода приложения в фон.
  Duration get appInBackgroundTime;

  /// Установить время перехода приложения в фон.
  Future<void> setGoToBackgroundTime(DateTime time);
}

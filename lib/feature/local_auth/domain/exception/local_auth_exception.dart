/// Общий класс ошибок фичи "Локальная аутентификация".
sealed class LocalAuthException implements Exception {
  const LocalAuthException();
}

/// Введенный пин-код не совпадает с подтвержденным.
class MismatchEnteredAndConfirmedPinCodeException extends LocalAuthException {
  const MismatchEnteredAndConfirmedPinCodeException();
}

/// Введенный пин-код неверный.
class IncorrectPinCodeException extends LocalAuthException {
  const IncorrectPinCodeException();
}

/// Исчерпано количество попыток ввода пин-кода.
class AttemptsExceededPinCodeException extends LocalAuthException {
  const AttemptsExceededPinCodeException();
}

/// Биометрия не доступна.
class BiometricsNotAvailableException extends LocalAuthException {
  const BiometricsNotAvailableException();
}

/// Аутентификация по биометрии не удалась.
class BiometricsAuthFailedException extends LocalAuthException {
  const BiometricsAuthFailedException();
}

/// Общая ошибка при Biometrics PlatformException.
class BiometricsAuthenticateException extends LocalAuthException {
  const BiometricsAuthenticateException();
}

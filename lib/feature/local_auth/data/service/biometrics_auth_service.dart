import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';

/// Доступные варианты аутентификации по биометрии.
class AvailableBiometrics {
  @visibleForTesting
  const AvailableBiometrics(Set<BiometricType> availableTypes)
    : _availableTypes = availableTypes;

  factory AvailableBiometrics.none() => const AvailableBiometrics({});

  final Set<BiometricType> _availableTypes;

  bool get none => _availableTypes.isEmpty;
  bool get any => _availableTypes.isNotEmpty;
  bool get containsFace => _availableTypes.contains(BiometricType.face);
  bool get containsFingerprint =>
      _availableTypes.contains(BiometricType.fingerprint);
}

/// Сервис аутентификации по биометрии устройства.
class BiometricsAuthService {
  BiometricsAuthService({
    required LocalAuthentication localAuth,
    required ErrorHandler errorHandler,
  }) : _localAuth = localAuth,
       _errorHandler = errorHandler;

  final LocalAuthentication _localAuth;
  final ErrorHandler _errorHandler;

  /// Возвращает доступные варианты аутентификации по биометрии.
  Future<AvailableBiometrics> get availableBiometricsType async {
    try {
      final canAuthenticate =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (!canAuthenticate) return AvailableBiometrics.none();

      final availableTypes = await _localAuth.getAvailableBiometrics();
      return AvailableBiometrics(availableTypes.toSet());
    } catch (e, st) {
      _errorHandler
          .sendError(
            e,
            st,
            type: '[BiometricsAuthService.availableBiometricsType]',
          )
          .ignore();
      return AvailableBiometrics.none();
    }
  }

  /// Аутентификация по биометрии.
  ///
  /// Возвращает true, если пользователь успешно аутентифицировался.
  /// [signInTitle] — заголовок окна аутентификации по биометрии
  /// [reason] — сообщение с указанием причины использования аутентификации по биометрии
  /// [cancelButton] — текст для кнопки отмены
  Future<bool> authenticate({
    required String signInTitle,
    required String reason,
    required String cancelButton,
  }) async {
    final result = await _localAuth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
      authMessages: <AuthMessages>[
        AndroidAuthMessages(
          signInTitle: signInTitle,
          biometricHint: '',
          cancelButton: cancelButton,
        ),
        IOSAuthMessages(cancelButton: cancelButton),
      ],
    );

    return result;
  }
}

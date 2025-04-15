part of 'bloc.dart';

/// События [BiometricsAuthBloc].
@immutable
sealed class BiometricsAuthEvent {
  final String signInTitle;
  final String reason;
  final String cancelButton;

  const BiometricsAuthEvent({
    required this.signInTitle,
    required this.reason,
    required this.cancelButton,
  });

  /// Запрос на аутентификацию по биометрии.
  ///
  /// [signInTitle] — заголовок окна аутентификации по биометрии
  /// [reason] — сообщение с указанием причины использования аутентификации по биометрии
  /// [cancelButton] — текст для кнопки отмены
  const factory BiometricsAuthEvent.authRequested({
    required String signInTitle,
    required String reason,
    required String cancelButton,
  }) = _AuthRequested;
}

final class _AuthRequested extends BiometricsAuthEvent {
  const _AuthRequested({
    required super.signInTitle,
    required super.reason,
    required super.cancelButton,
  });
}

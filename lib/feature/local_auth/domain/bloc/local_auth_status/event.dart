part of 'bloc.dart';

/// События [LocalAuthStatusBloc].
@immutable
sealed class LocalAuthStatusEvent {
  const LocalAuthStatusEvent();

  /// Проверка состояния локальной аутентификации.
  const factory LocalAuthStatusEvent.check() = _Check;
}

final class _Check extends LocalAuthStatusEvent {
  const _Check();
}

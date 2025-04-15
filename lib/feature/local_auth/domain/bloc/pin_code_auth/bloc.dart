import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/entity/attempts_enter_pin_code.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/entity/pin_code.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/exception/local_auth_exception.dart';

part 'event.dart';
part 'state.dart';

/// Блок аутентификации по пин-коду.
class PinCodeAuthBloc extends Bloc<PinCodeAuthEvent, PinCodeAuthState> {
  PinCodeAuthBloc({
    required LocalAuthRepository localAuthRepository,
    required ErrorHandler errorHandler,
  }) : _repository = localAuthRepository,
       _errorHandler = errorHandler,
       super(const PinCodeAuthState.entering()) {
    on<PinCodeAuthEvent>(
      (event, emit) => switch (event) {
        _NumberAdded() => _numberAdded(event, emit),
        _NumberDeleted() => _numberDeleted(event, emit),
        _PinCodeResetRequested() => _pinCodeResetRequested(event, emit),
        _ResetToEntering() => _resetToEntering(event, emit),
        _AuthByBiometrics() => _authByBiometrics(event, emit),
      },
    );
  }

  final LocalAuthRepository _repository;
  final ErrorHandler _errorHandler;

  Future<void> _numberAdded(
    _NumberAdded event,
    Emitter<PinCodeAuthState> emit,
  ) async {
    try {
      final enteredPin = state.pin + event.number;
      emit(
        PinCodeAuthState.entering(pin: enteredPin, attempts: state.attempts),
      );

      // Если длина введенного пин-кода не достигла максимальной, выходим
      if (!state.pin.isMaxLengthReached) {
        return;
      }

      // Если достигла, то проверяем введенный пин-код
      emit(
        PinCodeAuthState.authenticating(
          pin: state.pin,
          attempts: state.attempts,
        ),
      );
      final isPinMatch = await _repository.checkPinCode(state.pin);

      // Если совпадает, то переходим в состояние "Аутентифицирован" и
      // сбрасываем счетчик попыток.
      if (isPinMatch) {
        emit(
          PinCodeAuthState.authenticated(
            pin: state.pin,
            attempts: const AttemptsEnterPinCode(0),
          ),
        );
        return;
      }

      // Если не совпадает, то увеличиваем счетчик попыток
      final incrementedAttempts = state.attempts + 1;

      // Если достигнуто максимальное количество попыток
      if (incrementedAttempts.isMaxBeforeLogoutReached) {
        emit(
          PinCodeAuthState.reset(pin: state.pin, attempts: incrementedAttempts),
        );
        emit(
          PinCodeAuthState.error(
            error: const AttemptsExceededPinCodeException(),
            pin: state.pin,
            attempts: incrementedAttempts,
          ),
        );
      } else {
        // Если не достигнуто максимального количества попыток
        emit(
          PinCodeAuthState.error(
            error: const IncorrectPinCodeException(),
            pin: state.pin,
            attempts: incrementedAttempts,
          ),
        );
      }
    } catch (e, st) {
      _errorHandler
          .sendError(e, st, type: '[PinCodeAuthBloc._numberAdded]')
          .ignore();
      emit(
        PinCodeAuthState.error(
          error: e,
          pin: state.pin,
          attempts: state.attempts,
        ),
      );
    }
  }

  Future<void> _numberDeleted(
    _NumberDeleted event,
    Emitter<PinCodeAuthState> emit,
  ) async {
    if (state.pin.isEmpty) {
      return;
    }

    final updatedPin = state.pin.deleteLast();
    emit(PinCodeAuthState.entering(pin: updatedPin, attempts: state.attempts));
  }

  Future<void> _pinCodeResetRequested(
    _PinCodeResetRequested event,
    Emitter<PinCodeAuthState> emit,
  ) async {
    emit(PinCodeAuthState.reset(pin: state.pin, attempts: state.attempts));
    emit(const PinCodeAuthState.entering());
  }

  Future<void> _resetToEntering(
    _ResetToEntering event,
    Emitter<PinCodeAuthState> emit,
  ) async {
    emit(
      PinCodeAuthState.entering(
        pin: PinCode.empty(),
        attempts:
            event.resetAttempts
                ? const AttemptsEnterPinCode(0)
                : state.attempts,
      ),
    );
  }

  Future<void> _authByBiometrics(
    _AuthByBiometrics event,
    Emitter<PinCodeAuthState> emit,
  ) async {
    emit(
      PinCodeAuthState.authenticated(
        pin: state.pin,
        attempts: state.attempts,
        isBiometricsUsed: true,
      ),
    );
  }
}

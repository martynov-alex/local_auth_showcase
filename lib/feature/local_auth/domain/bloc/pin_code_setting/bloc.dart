import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/entity/pin_code.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/exception/local_auth_exception.dart';

part 'event.dart';
part 'state.dart';

/// Блок установки (изменения) пин-кода.
class PinCodeSettingBloc
    extends Bloc<PinCodeSettingEvent, PinCodeSettingState> {
  PinCodeSettingBloc({
    required LocalAuthRepository localAuthRepository,
    required ErrorHandler errorHandler,
  }) : _repository = localAuthRepository,
       _errorHandler = errorHandler,
       super(const PinCodeSettingState.entering()) {
    on<PinCodeSettingEvent>(
      (event, emit) => switch (event) {
        _NumberAdded() => _numberAdded(event, emit),
        _NumberDeleted() => _numberDeleted(event, emit),
        _ResetToEntering() => _resetToEntering(event, emit),
        _ResetToConfirming() => _resetToConfirming(event, emit),
      },
    );
  }

  final LocalAuthRepository _repository;
  final ErrorHandler _errorHandler;

  Future<void> _numberAdded(
    _NumberAdded event,
    Emitter<PinCodeSettingState> emit,
  ) async {
    try {
      if (state.isEnteringState) {
        _handleAddOnEntering(event, emit);
      } else {
        await _handleAddOnConfirming(event, emit);
      }
    } catch (e, st) {
      _errorHandler
          .sendError(e, st, type: '[PinCodeSettingBloc._numberAdded]')
          .ignore();
      emit(
        PinCodeSettingState.error(
          error: e,
          enteredPin: state.enteredPin,
          confirmedPin: state.confirmedPin,
        ),
      );
    }
  }

  Future<void> _numberDeleted(
    _NumberDeleted event,
    Emitter<PinCodeSettingState> emit,
  ) async {
    if (state.isEnteringState) {
      _handleDeleteOnEntering(event, emit);
    } else {
      _handleDeleteOnConfirming(event, emit);
    }
  }

  Future<void> _resetToEntering(
    _ResetToEntering event,
    Emitter<PinCodeSettingState> emit,
  ) async {
    emit(const PinCodeSettingState.entering());
  }

  void _handleAddOnEntering(
    _NumberAdded event,
    Emitter<PinCodeSettingState> emit,
  ) {
    final enteredPin = state.enteredPin + event.number;
    emit(
      PinCodeSettingState.entering(
        enteredPin: enteredPin,
        confirmedPin: state.confirmedPin,
      ),
    );

    // Если длина введенного пин-кода не достигла максимальной, выходим
    if (!state.enteredPin.isMaxLengthReached) {
      return;
    }

    // Если достигла, то переходим в состояние подтверждения ввода
    emit(
      PinCodeSettingState.confirming(
        enteredPin: state.enteredPin,
        confirmedPin: state.confirmedPin,
      ),
    );
  }

  Future<void> _handleAddOnConfirming(
    _NumberAdded event,
    Emitter<PinCodeSettingState> emit,
  ) async {
    // Если на момент нажатия уже достигнута максимальная длина, выходим
    if (state.confirmedPin.isMaxLengthReached) {
      return;
    }

    final confirmedPin = state.confirmedPin + event.number;
    emit(
      PinCodeSettingState.confirming(
        enteredPin: state.enteredPin,
        confirmedPin: confirmedPin,
      ),
    );

    // Если длина повторного пин-кода не достигла максимальной, выходим
    if (!state.confirmedPin.isMaxLengthReached) {
      return;
    }

    // Если достигла, то сравниваем введенный и повторный пин-коды
    // Если совпадают, то сохраняем пин-код
    if (state.isMatch) {
      emit(
        PinCodeSettingState.processing(
          enteredPin: state.enteredPin,
          confirmedPin: state.confirmedPin,
        ),
      );
      await _repository.savePinCode(state.confirmedPin);
      emit(
        PinCodeSettingState.success(
          enteredPin: state.enteredPin,
          confirmedPin: state.confirmedPin,
        ),
      );
      // Иначе — ошибка
    } else {
      emit(
        PinCodeSettingState.error(
          error: const MismatchEnteredAndConfirmedPinCodeException(),
          enteredPin: state.enteredPin,
          confirmedPin: state.confirmedPin,
        ),
      );
    }
  }

  Future<void> _resetToConfirming(
    _ResetToConfirming event,
    Emitter<PinCodeSettingState> emit,
  ) async {
    emit(
      PinCodeSettingState.confirming(
        enteredPin: state.enteredPin,
        confirmedPin: PinCode.empty(),
      ),
    );
  }

  void _handleDeleteOnEntering(
    _NumberDeleted event,
    Emitter<PinCodeSettingState> emit,
  ) {
    if (state.enteredPin.isEmpty) {
      return;
    }

    final updatedPin = state.enteredPin.deleteLast();
    emit(
      PinCodeSettingState.entering(
        enteredPin: updatedPin,
        confirmedPin: state.confirmedPin,
      ),
    );
  }

  void _handleDeleteOnConfirming(
    _NumberDeleted event,
    Emitter<PinCodeSettingState> emit,
  ) {
    if (state.confirmedPin.isEmpty) {
      return;
    }

    final updatedPin = state.confirmedPin.deleteLast();
    emit(
      PinCodeSettingState.confirming(
        enteredPin: state.enteredPin,
        confirmedPin: updatedPin,
      ),
    );
  }
}

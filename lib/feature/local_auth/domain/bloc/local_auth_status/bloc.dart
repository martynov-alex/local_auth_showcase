// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';

part 'event.dart';
part 'state.dart';

/// Блок проверки состояния локальной аутентификации.
class LocalAuthStatusBloc
    extends Bloc<LocalAuthStatusEvent, LocalAuthStatusState> {
  LocalAuthStatusBloc({
    required LocalAuthRepository localAuthRepository,
    required ErrorHandler errorHandler,
  }) : _localAuthRepository = localAuthRepository,
       _errorHandler = errorHandler,
       super(const LocalAuthStatusState.loading()) {
    on<LocalAuthStatusEvent>(
      (event, emit) => switch (event) {
        _Check() => _check(event, emit),
      },
    );
  }

  final LocalAuthRepository _localAuthRepository;
  final ErrorHandler _errorHandler;

  Future<void> _check(_Check event, Emitter<LocalAuthStatusState> emit) async {
    try {
      emit(const LocalAuthStatusState.loading());

      final isPinCodeSet = await _localAuthRepository.isPinCodeSet;
      final isBiometricsOn = await _localAuthRepository.isBiometricsOn;

      emit(
        LocalAuthStatusState.data(
          isPinCodeSet: isPinCodeSet,
          isBiometricsOn: isBiometricsOn,
        ),
      );
    } catch (e, st) {
      _errorHandler
          .sendError(e, st, type: '[LocalAuthStatusBloc._check]')
          .ignore();
      emit(LocalAuthStatusState.error(e));
    }
  }
}

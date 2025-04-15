import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/local_auth/data/service/biometrics_auth_service.dart';

part 'event.dart';
part 'state.dart';

/// Блок проверки доступности биометрии.
class BiometricsAvailabilityStatusBloc
    extends
        Bloc<
          BiometricsAvailabilityStatusEvent,
          BiometricsAvailabilityStatusState
        > {
  BiometricsAvailabilityStatusBloc({
    required BiometricsAuthService biometricsAuthService,
    required ErrorHandler errorHandler,
  }) : _biometricsAuthService = biometricsAuthService,
       _errorHandler = errorHandler,
       super(const BiometricsAvailabilityStatusState.loading()) {
    on<BiometricsAvailabilityStatusEvent>(
      (event, emit) => switch (event) {
        _Check() => _check(event, emit),
      },
    );
  }

  final BiometricsAuthService _biometricsAuthService;
  final ErrorHandler _errorHandler;

  Future<void> _check(
    _Check event,
    Emitter<BiometricsAvailabilityStatusState> emit,
  ) async {
    try {
      emit(const BiometricsAvailabilityStatusState.loading());

      final availableBiometrics =
          await _biometricsAuthService.availableBiometricsType;

      emit(
        BiometricsAvailabilityStatusState.data(
          availableBiometrics: availableBiometrics,
        ),
      );
    } catch (e, st) {
      _errorHandler
          .sendError(e, st, type: '[LocalAuthStatusBloc._check]')
          .ignore();
      emit(BiometricsAvailabilityStatusState.error(e));
    }
  }
}

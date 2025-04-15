import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/error_codes.dart' as local_auth_error_codes;
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/local_auth/data/service/biometrics_auth_service.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/exception/local_auth_exception.dart';

part 'event.dart';
part 'state.dart';

/// Блок аутентификации по биометрии.
class BiometricsAuthBloc
    extends Bloc<BiometricsAuthEvent, BiometricsAuthState> {
  BiometricsAuthBloc({
    required BiometricsAuthService biometricsAuthService,
    required ErrorHandler errorHandler,
  }) : _service = biometricsAuthService,
       _errorHandler = errorHandler,
       super(const BiometricsAuthState.notAuthenticated()) {
    on<BiometricsAuthEvent>(
      (event, emit) => switch (event) {
        _AuthRequested() => _authRequested(event, emit),
      },
    );
  }

  final BiometricsAuthService _service;
  final ErrorHandler _errorHandler;

  Future<void> _authRequested(
    _AuthRequested event,
    Emitter<BiometricsAuthState> emit,
  ) async {
    try {
      emit(const BiometricsAuthState.authenticating());

      final isAvailable = await _service.availableBiometricsType;

      if (isAvailable.none) {
        emit(
          const BiometricsAuthState.error(
            error: BiometricsNotAvailableException(),
          ),
        );
        return;
      }

      final isAuthenticated = await _service.authenticate(
        signInTitle: event.signInTitle,
        reason: event.reason,
        cancelButton: event.cancelButton,
      );

      if (isAuthenticated) {
        emit(const BiometricsAuthState.authenticated());
      } else {
        emit(
          const BiometricsAuthState.error(
            error: BiometricsAuthFailedException(),
          ),
        );
      }
    } on PlatformException catch (e, st) {
      const localAuthErrorCodes = {
        local_auth_error_codes.lockedOut,
        local_auth_error_codes.permanentlyLockedOut,
        local_auth_error_codes.notAvailable,
      };

      if (localAuthErrorCodes.contains(e.code)) {
        emit(
          const BiometricsAuthState.error(
            error: BiometricsAuthenticateException(),
          ),
        );
        return;
      }

      _errorHandler
          .sendError(e, st, type: '[BiometricsAuthBloc._authRequested]')
          .ignore();
      emit(BiometricsAuthState.error(error: e));
    } catch (e, st) {
      _errorHandler
          .sendError(e, st, type: '[BiometricsAuthBloc._authRequested]')
          .ignore();
      emit(BiometricsAuthState.error(error: e));
    }
  }
}

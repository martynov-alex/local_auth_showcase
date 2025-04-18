import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_repository.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/authentication_status.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    super.initialState, {
    required AuthRepository authRepository,
    required LocalAuthRepository localAuthRepository,
    required ErrorHandler errorHandler,
  }) : _authRepository = authRepository,
       _localAuthRepository = localAuthRepository,
       _errorHandler = errorHandler {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        final _SignInWithOAuth e => _signInWithOAuth(e, emit),
        final _LogOut e => _logout(e, emit),
      },
    );
  }

  final AuthRepository _authRepository;
  final LocalAuthRepository _localAuthRepository;
  final ErrorHandler _errorHandler;

  Future<void> _logout(_LogOut event, Emitter<AuthState> emit) async {
    emit(AuthState.logoutProcessing(status: state.status));

    try {
      await _authRepository.logout();
      await _localAuthRepository.deletePinCodeAndDisableBiometrics();
      emit(const AuthState.idle(status: AuthenticationStatus.unauthenticated));
    } on Object catch (e, stackTrace) {
      _errorHandler
          .sendError(e, stackTrace, type: '[AuthBloc._logout]')
          .ignore();
      emit(
        AuthState.error(status: AuthenticationStatus.unauthenticated, error: e),
      );
    }
  }

  Future<void> _signInWithOAuth(
    _SignInWithOAuth event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(status: state.status));

    try {
      await _authRepository.signInWithOAuth();
      emit(const AuthState.idle(status: AuthenticationStatus.authenticated));
    } on Object catch (e, stackTrace) {
      _errorHandler
          .sendError(e, stackTrace, type: '[AuthBloc._signInWithOAuth]')
          .ignore();
      emit(
        AuthState.error(status: AuthenticationStatus.unauthenticated, error: e),
      );
    }
  }
}

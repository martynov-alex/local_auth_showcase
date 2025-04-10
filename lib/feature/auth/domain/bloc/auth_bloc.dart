import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_repository.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/authentication_status.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository<Object> _authRepository;

  AuthBloc(super.initialState, {required AuthRepository<Object> authRepository})
    : _authRepository = authRepository {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        final _SignInWithOAuth e => _signInWithOAuth(e, emit),
        final _SignOut e => _signOut(e, emit),
      },
    );
  }

  Future<void> _signOut(_SignOut event, Emitter<AuthState> emit) async {
    emit(AuthState.processing(status: state.status));

    try {
      await _authRepository.signOut();
      emit(const AuthState.idle(status: AuthenticationStatus.unauthenticated));
    } on Object catch (e, stackTrace) {
      emit(
        AuthState.error(status: AuthenticationStatus.unauthenticated, error: e),
      );
      onError(e, stackTrace);
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
      emit(
        AuthState.error(status: AuthenticationStatus.unauthenticated, error: e),
      );
      onError(e, stackTrace);
    }
  }
}

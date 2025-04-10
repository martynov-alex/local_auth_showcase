import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/utils/app_bloc_observer.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_data_source.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_repository.dart';
import 'package:local_auth_showcase/feature/auth/data/token_storage.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/authentication_status.dart';
import 'package:logging/logging.dart' as logging;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = logging.Logger('Local Auth Showcase');
  Bloc.observer = AppBlocObserver(logger);

  final dependencies = await _initDependencies();

  runApp(App(dependencies: dependencies));
}

Future<Dependencies> _initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final storage = TokenStorageImpl(sharedPreferences: sharedPreferences);
  final token = await storage.load();

  final authBloc = AuthBloc(
    AuthState.idle(
      status:
          token != null
              ? AuthenticationStatus.authenticated
              : AuthenticationStatus.unauthenticated,
    ),
    authRepository: AuthRepositoryImpl(
      dataSource: FakeAuthDataSource(),
      storage: storage,
    ),
  );

  return Dependencies(sharedPreferences: sharedPreferences, authBloc: authBloc);
}

base class Dependencies {
  const Dependencies({required this.sharedPreferences, required this.authBloc});

  final SharedPreferences sharedPreferences;

  final AuthBloc authBloc;
}

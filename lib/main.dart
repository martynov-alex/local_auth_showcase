import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/service/error_handler.dart';
import 'package:local_auth_showcase/core/utils/app_bloc_observer.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_data_source.dart';
import 'package:local_auth_showcase/feature/auth/data/auth_repository.dart';
import 'package:local_auth_showcase/feature/auth/data/token_storage.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';
import 'package:local_auth_showcase/feature/auth/domain/entity/authentication_status.dart';
import 'package:local_auth_showcase/feature/local_auth/data/local_storage/local_storage.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository_impl.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_auth/bloc.dart';
import 'package:logging/logging.dart' as logging;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  logging.Logger.root.level = logging.Level.ALL;
  logging.Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });
  final logger = logging.Logger('Local Auth Showcase');
  Bloc.observer = AppBlocObserver(logger);

  final dependencies = await _initDependencies(logger);

  runApp(App(dependencies: dependencies));
}

Future<Dependencies> _initDependencies(logging.Logger logger) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final errorHandler = ErrorHandler(logger);
  final storage = TokenStorageImpl(sharedPreferences: sharedPreferences);
  final token = await storage.load();

  final localAuthLocalStorage = LocalAuthLocalStorageImpl(sharedPreferences);

  final localAuthRepository = LocalAuthRepositoryImpl(
    settingsStorage: localAuthLocalStorage,
    backgroundTimeStorage: localAuthLocalStorage,
  );

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
    localAuthRepository: localAuthRepository,
    errorHandler: errorHandler,
  );

  final localAuthStatusBloc = LocalAuthStatusBloc(
    localAuthRepository: localAuthRepository,
    errorHandler: errorHandler,
  )..add(LocalAuthStatusEvent.check());

  final pinCodeAuthBloc = PinCodeAuthBloc(
    localAuthRepository: localAuthRepository,
    errorHandler: errorHandler,
  );

  return Dependencies(
    sharedPreferences: sharedPreferences,
    logger: logger,
    errorHandler: errorHandler,
    authBloc: authBloc,
    localAuthRepository: localAuthRepository,
    localAuthStatusBloc: localAuthStatusBloc,
    pinCodeAuthBloc: pinCodeAuthBloc,
  );
}

base class Dependencies {
  const Dependencies({
    required this.sharedPreferences,
    required this.logger,
    required this.errorHandler,
    required this.authBloc,
    required this.localAuthRepository,
    required this.localAuthStatusBloc,
    required this.pinCodeAuthBloc,
  });

  final SharedPreferences sharedPreferences;
  final logging.Logger logger;
  final ErrorHandler errorHandler;
  final AuthBloc authBloc;
  final LocalAuthRepository localAuthRepository;
  final LocalAuthStatusBloc localAuthStatusBloc;
  final PinCodeAuthBloc pinCodeAuthBloc;
}

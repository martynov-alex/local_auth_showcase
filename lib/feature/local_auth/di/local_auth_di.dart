import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/data/service/biometrics_auth_service.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_availability_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_setting/bloc.dart';
import 'package:local_auth_showcase/main.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// DI для экрана аутентификации "Защищенного входа".
abstract final class LocalAuthDI {
  static List<SingleChildWidget> providers(Dependencies dependencies) {
    final errorHandler = dependencies.errorHandler;

    final biometricsAuthService = BiometricsAuthService(
      localAuth: LocalAuthentication(),
      errorHandler: errorHandler,
    );

    return [
      Provider<LocalAuthRepository>.value(
        value: dependencies.localAuthRepository,
      ),
      BlocProvider<LocalAuthStatusBloc>.value(
        value: dependencies.localAuthStatusBloc,
      ),
      BlocProvider<PinCodeAuthBloc>.value(value: dependencies.pinCodeAuthBloc),
      BlocProvider<PinCodeSettingBloc>(
        create:
            (_) => PinCodeSettingBloc(
              localAuthRepository: dependencies.localAuthRepository,
              errorHandler: errorHandler,
            ),
      ),
      BlocProvider<BiometricsAuthBloc>(
        create:
            (_) => BiometricsAuthBloc(
              biometricsAuthService: biometricsAuthService,
              errorHandler: errorHandler,
            ),
      ),
      BlocProvider<BiometricsAvailabilityStatusBloc>(
        create:
            (_) => BiometricsAvailabilityStatusBloc(
              biometricsAuthService: biometricsAuthService,
              errorHandler: errorHandler,
            )..add(const BiometricsAvailabilityStatusEvent.check()),
      ),
    ];
  }
}

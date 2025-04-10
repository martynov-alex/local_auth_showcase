import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/extensions/string_extension.dart';
import 'package:logging/logging.dart' as logging;

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this.logger);

  final logging.Logger logger;

  @override
  void onTransition(
    Bloc<Object?, Object?> bloc,
    Transition<Object?, Object?> transition,
  ) {
    final logMessage =
        StringBuffer()
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..writeln('Event: ${transition.event.runtimeType}')
          ..writeln(
            'Transition: ${transition.currentState.runtimeType} => '
            '${transition.nextState.runtimeType}',
          )
          ..write('New State: ${transition.nextState?.toString().limit(100)}');

    logger.info(logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage =
        StringBuffer()
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..writeln('Event: ${event.runtimeType}')
          ..write('Details: ${event?.toString().limit(200)}');

    logger.info(logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage =
        StringBuffer()
          ..writeln('Bloc: ${bloc.runtimeType}')
          ..writeln(error.toString());

    logger.severe(logMessage.toString(), error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

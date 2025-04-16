import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/core/router/router.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/local_auth_screen.dart';
import 'package:local_auth_showcase/main.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final Dependencies _dependencies;
  late final StreamToListenable _listenable;
  late final GoRouter _router;
  late final AppLifecycleListener _localAuthAppLifecycleListener;

  @override
  void initState() {
    super.initState();
    _dependencies = DependenciesScope.of(context);
    _listenable = StreamToListenable([_dependencies.authBloc.stream]);
    _router = AppRouter.getRouter(_listenable);
    _localAuthAppLifecycleListener = _getLocalAuthAppLifecycleListener(context);
    _showLocalAuthDialog();
  }

  void _showLocalAuthDialog() async {
    await showLocalAuthDialog(
      _dependencies,
      onFailure: () {
        context.read<AuthBloc>().add(const AuthEvent.logout());
      },
    );
  }

  @override
  void dispose() {
    _listenable.dispose();
    _localAuthAppLifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
      builder:
          (context, child) => FlutterEasyDialogs(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Stack(
                    children: [
                      AbsorbPointer(
                        absorbing: state.isLogoutProcessing,
                        child: child!,
                      ),
                      if (state.isLogoutProcessing) ...[
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: context.colorScheme.onPrimary,
                            strokeWidth: 8,
                            constraints: BoxConstraints.tight(Size(40, 40)),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
    );
  }

  AppLifecycleListener _getLocalAuthAppLifecycleListener(BuildContext context) {
    const delayBeforeBlockDev = Duration(seconds: 10);
    const delayBeforeBlockProd = Duration(minutes: 5);

    final localAuthRepository = _dependencies.localAuthRepository;
    final logger = _dependencies.logger;

    return AppLifecycleListener(
      onInactive: () {
        localAuthRepository.setGoToBackgroundTime(DateTime.now());
        logger.fine(
          'LocalAuthBackgroundService.AppLifecycleListener.onInactive: time ${DateTime.now()}',
        );
      },
      onResume: () {
        final blockTime =
            kDebugMode ? delayBeforeBlockDev : delayBeforeBlockProd;

        final appInBackgroundTime = localAuthRepository.appInBackgroundTime;

        if (appInBackgroundTime > blockTime) {
          showLocalAuthDialog(
            _dependencies,
            onFailure: () {
              context.read<AuthBloc>().add(const AuthEvent.logout());
            },
          );
          logger.fine(
            'LocalAuthBackgroundService.AppLifecycleListener.onResume: app blocked at ${DateTime.now()}',
          );
        }
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final baseTheme = switch (brightness) {
      Brightness.light => ThemeData.light(useMaterial3: true),
      Brightness.dark => ThemeData.dark(useMaterial3: true),
    };

    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness: brightness,
      ),
      textTheme: GoogleFonts.jostTextTheme(baseTheme.textTheme),
    );
  }
}

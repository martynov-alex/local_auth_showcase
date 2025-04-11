import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth_showcase/core/router/router.dart';
import 'package:local_auth_showcase/feature/app/app.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final GoRouter _router;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = DependenciesScope.of(context).authBloc;
    _router = AppRouter.getRouter(_authBloc);
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
          (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
            child: child!,
          ),
    );
  }
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
    textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme),
  );
}

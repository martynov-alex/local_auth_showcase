import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth_showcase/core/router/router.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
      ),
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

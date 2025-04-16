import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/router/route_wrapper.dart';
import 'package:local_auth_showcase/core/router/routes.dart';
import 'package:local_auth_showcase/feature/auth/domain/bloc/auth_bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/di/local_auth_di.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/authentication/view.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/onboarding/view.dart';
import 'package:local_auth_showcase/main.dart';
import 'package:provider/provider.dart';

class LocalAuthInitialScreen extends StatelessWidget implements RouteWrapper {
  const LocalAuthInitialScreen({super.key});

  @override
  Widget wrappedRoute(Dependencies dependencies) {
    return MultiProvider(
      providers: LocalAuthDI.providers(dependencies),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _LocalAuthInitialMain();
  }
}

class _LocalAuthInitialMain extends StatefulWidget {
  const _LocalAuthInitialMain();

  @override
  State<_LocalAuthInitialMain> createState() => _LocalAuthInitialMainState();
}

class _LocalAuthInitialMainState extends State<_LocalAuthInitialMain> {
  late final AuthBloc _authBloc;
  late final LocalAuthStatusBloc _localAuthStatusBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
    _localAuthStatusBloc = context.read<LocalAuthStatusBloc>();
    _localAuthStatusBloc.add(const LocalAuthStatusEvent.check());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAuthStatusBloc, LocalAuthStatusState>(
      builder: (context, state) {
        return switch (state) {
          LocalAuthStatusLoading() => const SizedBox.shrink(),
          LocalAuthStatusError() => const SizedBox.shrink(),
          LocalAuthStatusData(isPinCodeSet: true) =>
            LocalAuthAuthenticationView(
              isBiometricsEnabled: false,
              onSuccess: () {
                LocalAuthSettingsRouteData().go(context);
              },
              onFailure: () {
                _authBloc.add(const AuthEvent.signOut());
              },
            ),
          LocalAuthStatusData(isPinCodeSet: false) =>
            const LocalAuthOnboardingView(),
        };
      },
    );
  }
}

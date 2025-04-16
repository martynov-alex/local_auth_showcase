import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_showcase/core/router/modal/pin_code_setting.dart';
import 'package:local_auth_showcase/core/router/routes.dart';
import 'package:local_auth_showcase/feature/local_auth/data/repository/repository.dart';
import 'package:local_auth_showcase/feature/local_auth/data/service/biometrics_auth_service.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/biometrics_availability_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/local_auth_status/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/bloc/pin_code_auth/bloc.dart';
import 'package:local_auth_showcase/feature/local_auth/domain/exception/local_auth_exception.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/settings/disable_modal.dart';

class LocalAuthSettingsView extends StatefulWidget {
  const LocalAuthSettingsView({super.key});

  @override
  State<LocalAuthSettingsView> createState() => _LocalAuthSettingsViewState();
}

class _LocalAuthSettingsViewState extends State<LocalAuthSettingsView> {
  late final LocalAuthRepository _localAuthRepository;
  late final LocalAuthStatusBloc _localAuthStatusBloc;
  late final BiometricsAuthBloc _biometricsAuthBloc;
  late final BiometricsAvailabilityStatusBloc _biometricsAvailabilityBloc;

  @override
  void initState() {
    super.initState();
    _localAuthRepository = context.read<LocalAuthRepository>();
    _localAuthStatusBloc = context.read<LocalAuthStatusBloc>();
    _biometricsAuthBloc = context.read<BiometricsAuthBloc>();
    _biometricsAvailabilityBloc =
        context.read<BiometricsAvailabilityStatusBloc>();
  }

  Future<void> _onDisablePinCodeTap() async {
    await _localAuthRepository.deletePinCodeAndDisableBiometrics();
    _localAuthStatusBloc.add(const LocalAuthStatusEvent.check());

    if (mounted) LocalAuthInitialRouteData().go(context);
  }

  Future<void> _onBiometricsSwitchTap(
    bool isSwitchedOn, {
    required AvailableBiometrics availableBiometrics,
  }) async {
    if (isSwitchedOn) {
      await _localAuthRepository.enableBiometricsForLogin();
      if (mounted && Theme.of(context).platform == TargetPlatform.iOS) {
        _biometricsAuthBloc.add(
          BiometricsAuthEvent.authRequested(
            signInTitle: "localAuthConfirmBiometricsTitle",
            reason: "localAuthConfirmBiometricsReason",
            cancelButton: "cancel",
          ),
        );
      }
    } else {
      await _localAuthRepository.disableBiometricsForLogin();
    }
    _localAuthStatusBloc.add(const LocalAuthStatusEvent.check());
  }

  Future<void> _showDisableModal(VoidCallback onTap) async {
    await showDialog(
      context: context,
      builder:
          (BuildContext context) => SafeArea(
            child: LocalAuthDisableModal(
              onConfirmTap: () {
                onTap.call();
              },
              onCancelTap: () {},
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PinCodeAuthBloc, PinCodeAuthState>(
          listenWhen: (prev, next) => !prev.isReset && next.isReset,
          listener: (context, _) {},
        ),
        BlocListener<BiometricsAuthBloc, BiometricsAuthState>(
          listenWhen:
              (prev, next) =>
                  (!prev.isError && next.isError) ||
                  (!prev.isAuthenticated && next.isAuthenticated),
          listener: (context, state) {
            if (state.error is BiometricsAuthenticateException ||
                state.isAuthenticated) {
              _biometricsAvailabilityBloc.add(
                const BiometricsAvailabilityStatusEvent.check(),
              );
            }
          },
        ),
      ],
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 6),
          ListTile(
            onTap: () async {
              await openPinCodeSettingModal(
                context,
                enteringStageText: "localAuthCreateNewPinCode",
              );
            },
            title: Text("localAuthChangePinCode"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          ListTile(
            onTap: () async {
              await _showDisableModal(_onDisablePinCodeTap);
            },

            title: Text("localAuthDisablePinCode"),
          ),
          _SettingsTrailing(onTap: _onBiometricsSwitchTap),
          const SizedBox.square(dimension: kBottomNavigationBarHeight),
        ],
      ),
    );
  }
}

class _SettingsTrailing extends StatelessWidget {
  const _SettingsTrailing({required this.onTap});

  final Future<void> Function(
    bool, {
    required AvailableBiometrics availableBiometrics,
  })
  onTap;

  String _switchTitleOf(
    BuildContext context,
    AvailableBiometrics availableBiometrics,
  ) {
    if (Theme.of(context).platform == TargetPlatform.iOS &&
        availableBiometrics.containsFace) {
      return "localAuthBiometricsSwitchFace";
    }
    if (Theme.of(context).platform == TargetPlatform.iOS &&
        availableBiometrics.containsFingerprint) {
      return "localAuthBiometricsSwitchFingerprint";
    }

    return "localAuthBiometricsSwitch";
  }

  String _switchSubtitleOf(
    BuildContext context,
    AvailableBiometrics availableBiometrics,
  ) {
    if (Theme.of(context).platform == TargetPlatform.iOS &&
        (availableBiometrics.containsFace ||
            availableBiometrics.containsFingerprint)) {
      return "localAuthBiometricsSwitchReason";
    }

    return "localAuthBiometricsSwitchAny";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BiometricsAvailabilityStatusBloc,
      BiometricsAvailabilityStatusState
    >(
      builder: (_, biometricsState) {
        if (biometricsState.isBiometricsAvailable) {
          return BlocBuilder<LocalAuthStatusBloc, LocalAuthStatusState>(
            builder: (_, authStatusState) {
              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                title: Text(
                  _switchTitleOf(context, biometricsState.availableBiometrics),
                ),
                subtitle: Text(
                  _switchSubtitleOf(
                    context,
                    biometricsState.availableBiometrics,
                  ),
                ),
                trailing: Switch(
                  value: authStatusState.isBiometricsOn,
                  onChanged:
                      (isSwitchedOn) => onTap(
                        isSwitchedOn,
                        availableBiometrics:
                            biometricsState.availableBiometrics,
                      ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

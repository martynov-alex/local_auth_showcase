import 'package:flutter/material.dart';

class LocalAuthDisableModal extends StatelessWidget {
  const LocalAuthDisableModal({
    required this.onConfirmTap,
    required this.onCancelTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('localAuthModalDisablePinTitle'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: onConfirmTap,
                child: const Text('localAuthModalDisablePinButton'),
              ),
              const SizedBox(height: 15),
              TextButton(onPressed: onCancelTap, child: const Text('cancel')),
            ],
          ),
        ),
      ),
    );
  }
}

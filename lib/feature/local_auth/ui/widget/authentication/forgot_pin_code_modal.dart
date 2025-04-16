import 'package:flutter/material.dart';

class ForgotPinCodeModal extends StatelessWidget {
  const ForgotPinCodeModal({
    required this.onConfirmTap,
    required this.onCancelTap,
    super.key,
  });

  final VoidCallback onConfirmTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onCancelTap,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Dialog.fullscreen(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('localAuthModalForgotPinTitle'),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: onConfirmTap,
                    child: const Text('localAuthModalForgotPinButton'),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: onCancelTap,
                    child: const Text('cancel'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

Future<void> showModalDialog({
  required String id,
  required Widget content,
}) async {
  final modal = EasyDialog.positioned(
    id: id,
    position: EasyDialogPosition.bottom,
    animationConfiguration: const EasyDialogAnimationConfiguration.bounded(
      duration: Duration(milliseconds: 200),
    ),
    decoration: const EasyDialogAnimation.fadeBackground(
      backgroundColor: Colors.transparent,
      blur: 10,
      curve: Curves.easeInOut,
    ),
    autoHideDuration: null,
    content: content,
  );

  await modal.show();
}

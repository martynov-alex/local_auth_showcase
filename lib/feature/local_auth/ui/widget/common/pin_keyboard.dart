import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/circle_number_button.dart';
import 'package:local_auth_showcase/feature/local_auth/ui/widget/common/custom_keyboard_button.dart';

class PinKeyboard extends StatelessWidget {
  const PinKeyboard({
    required this.textButtonTitle,
    required this.iconButtonChild,
    required this.onIconTap,
    required this.onTextTap,
    required this.onNumberTap,
    required this.isBlocked,
    super.key,
  });

  final String textButtonTitle;
  final Widget iconButtonChild;
  final VoidCallback onIconTap;
  final VoidCallback onTextTap;
  final bool isBlocked;
  final void Function(String number) onNumberTap;

  static const double _buttonSpacing = 24;
  static const double _rowSpacing = 16;

  void onNumberTapWithHaptics(String number) {
    HapticFeedback.lightImpact();
    onNumberTap(number);
  }

  void onTextTapWithHaptics() {
    HapticFeedback.lightImpact();
    onTextTap();
  }

  void onIconTapWithHaptics() {
    HapticFeedback.lightImpact();
    onIconTap();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isBlocked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 1),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 2),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 3),
            ],
          ),
          const SizedBox.square(dimension: _rowSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 4),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 5),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 6),
            ],
          ),
          const SizedBox.square(dimension: _rowSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 7),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 8),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 9),
            ],
          ),
          const SizedBox.square(dimension: _rowSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomKeyboardButton(
                onTap: onTextTapWithHaptics,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 10,
                ),
                child: Text(
                  textButtonTitle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: context.textTheme.labelMedium,
                ),
              ),
              const SizedBox.square(dimension: _buttonSpacing),
              CircleNumberButton(onTap: onNumberTapWithHaptics, number: 0),
              const SizedBox.square(dimension: _buttonSpacing),
              CustomKeyboardButton(
                onTap: onIconTapWithHaptics,
                padding: const EdgeInsets.all(14),
                child: iconButtonChild,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

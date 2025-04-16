import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

class CircleNumberButton extends StatefulWidget {
  const CircleNumberButton({
    required this.onTap,
    required this.number,
    super.key,
  });

  final int number;
  final void Function(String number) onTap;

  @override
  State<CircleNumberButton> createState() => _CircleNumberButtonState();
}

class _CircleNumberButtonState extends State<CircleNumberButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.number.toString());
        setState(() => _isPressed = true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              _isPressed
                  ? context.colorScheme.primary
                  : context.colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            widget.number.toString(),
            style: context.textTheme.labelMedium,
          ),
        ),
        onEnd: () => setState(() => _isPressed = false),
      ),
    );
  }
}

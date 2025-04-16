import 'package:flutter/material.dart';

class CustomKeyboardButton extends StatelessWidget {
  const CustomKeyboardButton({
    required this.onTap,
    required this.padding,
    required this.child,
    super.key,
  });

  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 72,
        child: Center(child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:local_auth_showcase/core/extensions/theme_extension.dart';

/// Виджет для отображения индикатора ввода PIN-кода
class PinIndicator extends StatelessWidget {
  const PinIndicator({
    required this.maxPinLength,
    required this.currentPinLength,
    required this.statusText,
    this.indicatorTextColor,
    this.indicatorDotColor,
    super.key,
  });

  /// Общее количество символов в коде
  final int maxPinLength;

  /// Текущее количество введенных символов
  final int currentPinLength;

  /// Текст статуса ввода пин-кода
  final String statusText;

  /// Цвет для индикации состояния текста
  final Color? indicatorTextColor;

  /// Цвет для индикации состояния точек
  final Color? indicatorDotColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          statusText,
          style: context.textTheme.labelMedium?.copyWith(
            color: indicatorTextColor,
          ),
        ),
        const SizedBox.square(dimension: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxPinLength, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getDotColor(context, index),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Определяем цвет точки в зависимости от состояния ввода
  Color _getDotColor(BuildContext context, int index) {
    final indicatorDotColor = this.indicatorDotColor;

    if (indicatorDotColor != null) return indicatorDotColor;
    if (index < currentPinLength) return context.colorScheme.tertiary;
    return context.colorScheme.primary;
  }
}

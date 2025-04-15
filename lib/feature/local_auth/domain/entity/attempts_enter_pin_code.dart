// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const _maxAttemptsBeforeWarning = 7;
const _maxAttemptsBeforeLogout = 10;

/// Сущность количества попыток ввода пин-кода.
@immutable
class AttemptsEnterPinCode extends Equatable {
  final int count;

  const AttemptsEnterPinCode(this.count);

  /// Достигнуто ли количество попыток, при котором надо отобразить предупреждение.
  bool get isMaxBeforeWarningReached => count >= _maxAttemptsBeforeWarning;

  /// Достигнуто ли максимально количество попыток для логаута.
  bool get isMaxBeforeLogoutReached => count >= _maxAttemptsBeforeLogout;

  /// Сколько осталось попыток для логаута.
  int get numberAttemptsBeforeLogout => _maxAttemptsBeforeLogout - count;

  /// Оператор сложения.
  AttemptsEnterPinCode operator +(int other) {
    assert(other == 1, 'Попытки могут увеличиваться только на 1');
    return AttemptsEnterPinCode(count + other);
  }

  @override
  List<Object> get props => [count];
}

// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

const _maxPinCodeLength = 4;

// Сущность пин-кода.
@immutable
class PinCode extends Equatable {
  final String value;

  const PinCode(this.value);

  factory PinCode.empty() => const PinCode('');

  /// Максимальная длина пин-кода.
  static const maxPinCodeLength = _maxPinCodeLength;

  /// Достигнута ли максимальная длина.
  bool get isMaxLengthReached => value.length >= _maxPinCodeLength;

  /// Пустой ли пин-код.
  bool get isEmpty => value.isEmpty;

  /// Удаляет последний символ из пин-кода.
  PinCode deleteLast() => PinCode(value.substring(0, value.length - 1));

  /// Оператор сложения.
  PinCode operator +(String other) {
    assert(other.length == 1, 'Длина добавляемого символа должна быть 1');
    return PinCode(value + other);
  }

  @override
  List<Object> get props => [value];
}

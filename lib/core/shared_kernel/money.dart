import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final double amount;

  const Money._(this.amount);

  factory Money.fromDouble(double value) {
    if (value < 0) {
      throw ArgumentError('Money amount cannot be negative');
    }
    return Money._(value);
  }

  factory Money.zero() => const Money._(0.0);

  Money operator +(Money other) => Money._(amount + other.amount);
  Money operator -(Money other) {
    final result = amount - other.amount;
    if (result < 0) {
      throw ArgumentError('Money amount cannot be negative after subtraction');
    }
    return Money._(result);
  }

  Money operator *(double multiplier) => Money._(amount * multiplier);

  bool operator >(Money other) => amount > other.amount;
  bool operator <(Money other) => amount < other.amount;
  bool operator >=(Money other) => amount >= other.amount;
  bool operator <=(Money other) => amount <= other.amount;

  bool get isZero => amount == 0.0;
  bool get isPositive => amount > 0.0;

  String toFormattedString({String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [amount];
}

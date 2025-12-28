import 'package:equatable/equatable.dart';
import '../../../../core/shared_kernel/money.dart';

class ShiftEntity extends Equatable {
  final String id;
  final String employeeId;
  final String cashRegisterId;
  final Money initialCash;
  final Money? finalCash;
  final DateTime startedAt;
  final DateTime? endedAt;

  const ShiftEntity({
    required this.id,
    required this.employeeId,
    required this.cashRegisterId,
    required this.initialCash,
    this.finalCash,
    required this.startedAt,
    this.endedAt,
  });

  bool get isActive => endedAt == null;

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        cashRegisterId,
        initialCash,
        finalCash,
        startedAt,
        endedAt,
      ];
}

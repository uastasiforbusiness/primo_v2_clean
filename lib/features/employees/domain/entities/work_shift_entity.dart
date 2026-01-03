import 'package:equatable/equatable.dart';

class WorkShiftEntity extends Equatable {
  final String id;
  final String employeeId;
  final DateTime clockIn;
  final DateTime? clockOut;
  final double? hourlyRateSnapshot;

  const WorkShiftEntity({
    required this.id,
    required this.employeeId,
    required this.clockIn,
    this.clockOut,
    this.hourlyRateSnapshot,
  });

  bool get isFinished => clockOut != null;

  @override
  List<Object?> get props => [id, employeeId, clockIn, clockOut, hourlyRateSnapshot];
}

import 'package:primo_v2/features/employees/domain/entities/work_shift_entity.dart';
import '../../../../infrastructure/database/app_database.dart';

class WorkShiftModel extends WorkShiftEntity {
  const WorkShiftModel({
    required super.id,
    required super.employeeId,
    required super.clockIn,
    super.clockOut,
    super.hourlyRateSnapshot,
  });

  factory WorkShiftModel.fromDrift(WorkShift shift) {
    return WorkShiftModel(
      id: shift.id,
      employeeId: shift.employeeId,
      clockIn: shift.clockIn,
      clockOut: shift.clockOut,
      hourlyRateSnapshot: shift.hourlyRateSnapshot,
    );
  }
}

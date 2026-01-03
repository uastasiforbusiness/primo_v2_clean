import '../../../../core/shared_kernel/money.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.employeeId,
    required super.cashRegisterId,
    required super.initialCash,
    super.finalCash,
    required super.startedAt,
    super.endedAt,
  });

  factory ShiftModel.fromDrift(Shift shift) {
    return ShiftModel(
      id: shift.id,
      employeeId: shift.employeeId,
      cashRegisterId: shift.cashRegisterId,
      initialCash: Money.fromDouble(shift.initialCash),
      finalCash: shift.finalCash != null ? Money.fromDouble(shift.finalCash!) : null,
      startedAt: shift.startedAt,
      endedAt: shift.endedAt,
    );
  }

  ShiftEntity toEntity() {
    return ShiftEntity(
      id: id,
      employeeId: employeeId,
      cashRegisterId: cashRegisterId,
      initialCash: initialCash,
      finalCash: finalCash,
      startedAt: startedAt,
      endedAt: endedAt,
    );
  }
}

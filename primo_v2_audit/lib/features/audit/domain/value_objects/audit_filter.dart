import 'package:equatable/equatable.dart';

/// Value Object para filtros de auditoría
class AuditFilter extends Equatable {
  final String? eventType;
  final String? employeeId;
  final DateTime? startDate;
  final DateTime? endDate;

  const AuditFilter({
    this.eventType,
    this.employeeId,
    this.startDate,
    this.endDate,
  });

  bool get hasFilters =>
      eventType != null || employeeId != null || startDate != null || endDate != null;

  AuditFilter copyWith({
    String? eventType,
    String? employeeId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AuditFilter(
      eventType: eventType ?? this.eventType,
      employeeId: employeeId ?? this.employeeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [eventType, employeeId, startDate, endDate];
}

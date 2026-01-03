import 'package:equatable/equatable.dart';

/// Value Object para tipos de eventos de auditoría
class AuditEventType extends Equatable {
  final String value;

  const AuditEventType._(this.value);

  // Eventos de autenticación
  static const loginSuccess = AuditEventType._('login_success');
  static const loginFailed = AuditEventType._('login_failed');
  static const logout = AuditEventType._('logout');

  // Eventos de turnos
  static const clockIn = AuditEventType._('clock_in');
  static const clockOut = AuditEventType._('clock_out');
  static const breakStart = AuditEventType._('break_start');
  static const breakEnd = AuditEventType._('break_end');

  // Eventos de empleados
  static const employeeCreated = AuditEventType._('employee_created');
  static const employeeUpdated = AuditEventType._('employee_updated');
  static const employeeDeleted = AuditEventType._('employee_deleted');

  // Eventos de ventas (futuro)
  static const saleCreated = AuditEventType._('sale_created');
  static const saleCancelled = AuditEventType._('sale_cancelled');

  factory AuditEventType.fromString(String value) {
    return AuditEventType._(value);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

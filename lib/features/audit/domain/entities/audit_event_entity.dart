import 'package:equatable/equatable.dart';

/// Entidad de dominio para eventos de auditoría
///
/// Representa un evento inmutable en el sistema que debe ser registrado
/// para trazabilidad y cumplimiento normativo.
class AuditEventEntity extends Equatable {
  final String id;
  final String eventType;
  final String? employeeId;
  final String? metadata; // JSON string que representa un Map<String, dynamic>
  final DateTime createdAt;

  const AuditEventEntity({
    required this.id,
    required this.eventType,
    this.employeeId,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, eventType, employeeId, metadata, createdAt];
}

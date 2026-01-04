import 'dart:convert';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/entities/audit_event_entity.dart';

/// Modelo de datos para eventos de auditoría
///
/// Convierte entre la representación de Drift y la entidad de dominio
class AuditEventModel extends AuditEventEntity {
  const AuditEventModel({
    required super.id,
    required super.eventType,
    super.employeeId,
    super.metadata,
    required super.createdAt,
  });

  /// Crea un modelo desde una fila de Drift
  factory AuditEventModel.fromDrift(AuditEvent event) {
    // Convertir el JSON string de metadatos a Map<String, dynamic>
    Map<String, dynamic>? parsedMetadata;
    if (event.metadata != null) {
      try {
        final decoded = jsonDecode(event.metadata!);
        if (decoded is Map<String, dynamic>) {
          parsedMetadata = decoded;
        }
      } catch (e) {
        // Si hay un error al decodificar, mantener como string original
        parsedMetadata = {'raw_data': event.metadata};
      }
    }

    return AuditEventModel(
      id: event.id,
      eventType: event.eventType,
      employeeId: event.employeeId,
      metadata: parsedMetadata != null ? jsonEncode(parsedMetadata) : null,
      createdAt: event.createdAt,
    );
  }

  /// Convierte el modelo a entidad de dominio
  AuditEventEntity toEntity() {
    return AuditEventEntity(
      id: id,
      eventType: eventType,
      employeeId: employeeId,
      metadata: metadata,
      createdAt: createdAt,
    );
  }
}

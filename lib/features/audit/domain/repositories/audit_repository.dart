import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/audit_event_entity.dart';
import '../value_objects/audit_filter.dart';
import '../value_objects/audit_sort.dart';

/// Puerto del dominio para operaciones de auditoría
abstract class AuditRepository {
  /// Registra un nuevo evento de auditoría
  Future<Either<Failure, void>> logEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  });

  /// Obtiene todos los eventos de auditoría con filtros y ordenamiento
  Future<Either<Failure, List<AuditEventEntity>>> getAuditEvents({
    AuditFilter? filter,
    AuditSort? sort,
    int? limit,
  });

  /// Obtiene un evento específico por ID
  Future<Either<Failure, AuditEventEntity?>> getEventById(String id);

  /// Obtiene el conteo de eventos (útil para paginación futura)
  Future<Either<Failure, int>> getEventCount({AuditFilter? filter});
}

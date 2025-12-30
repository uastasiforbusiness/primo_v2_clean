import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/audit_event_entity.dart';
import '../repositories/audit_repository.dart';
import '../value_objects/audit_filter.dart';
import '../value_objects/audit_sort.dart';

/// Caso de uso para obtener eventos de auditoría con filtros y ordenamiento
///
/// Reglas de negocio:
/// - Por defecto, ordena por fecha descendente (más recientes primero)
/// - Si se especifica un límite, debe ser positivo
/// - Los filtros son opcionales y se combinan con AND
class GetAuditEventsUseCase {
  final AuditRepository repository;

  GetAuditEventsUseCase(this.repository);

  Future<Either<Failure, List<AuditEventEntity>>> call({
    AuditFilter? filter,
    AuditSort? sort,
    int? limit,
  }) async {
    // Validación de límite
    if (limit != null && limit <= 0) {
      return const Left(
        ValidationFailure(message: 'Limit must be positive'),
      );
    }

    // Usar ordenamiento por defecto si no se especifica
    final effectiveSort = sort ?? AuditSort.defaultSort;

    return await repository.getAuditEvents(
      filter: filter,
      sort: effectiveSort,
      limit: limit,
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/audit_repository.dart';

/// Caso de uso para registrar eventos de auditoría
///
/// Reglas de negocio:
/// - El eventType es obligatorio
/// - Los eventos son inmutables una vez creados
/// - Debe ejecutarse en una transacción ACID
class LogAuditEventUseCase {
  final AuditRepository repository;

  LogAuditEventUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  }) async {
    // Validación básica
    if (eventType.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Event type cannot be empty'),
      );
    }

    return await repository.logEvent(
      eventType: eventType,
      employeeId: employeeId,
      metadata: metadata,
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/audit_event_entity.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';
import '../datasources/audit_local_datasource.dart';
import '../models/audit_event_model.dart';

/// Implementación del repositorio de auditoría
///
/// Adaptador que conecta el dominio con la capa de datos
class AuditRepositoryImpl implements AuditRepository {
  final AuditLocalDataSource localDataSource;

  AuditRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> logEvent({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await localDataSource.logEvent(
        eventType: eventType,
        employeeId: employeeId,
        metadata: metadata,
      );
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AuditEventEntity>>> getAuditEvents({
    AuditFilter? filter,
    AuditSort? sort,
    int? limit,
  }) async {
    try {
      final events = await localDataSource.getAuditEvents(
        filter: filter,
        sort: sort,
        limit: limit,
      );

      final entities = events
          .map((event) => AuditEventModel.fromDrift(event).toEntity())
          .toList();

      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AuditEventEntity?>> getEventById(String id) async {
    try {
      final event = await localDataSource.getEventById(id);
      
      if (event == null) {
        return const Right(null);
      }

      final entity = AuditEventModel.fromDrift(event).toEntity();
      return Right(entity);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getEventCount({AuditFilter? filter}) async {
    try {
      final count = await localDataSource.getEventCount(filter: filter);
      return Right(count);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}

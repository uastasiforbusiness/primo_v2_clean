import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';

/// Interfaz del datasource local de auditoría
abstract class AuditLocalDataSource {
  Future<void> logEvent({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  });

  Future<List<AuditEvent>> getAuditEvents({
    AuditFilter? filter,
    AuditSort? sort,
    int? limit,
  });

  Future<AuditEvent?> getEventById(String id);

  Future<int> getEventCount({AuditFilter? filter});
}

/// Implementación del datasource usando Drift
class AuditLocalDataSourceImpl implements AuditLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;

  AuditLocalDataSourceImpl({
    required this.database,
    required this.uuid,
  });

  @override
  Future<void> logEvent({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Convertir el Map a JSON string antes de guardarlo
      String? jsonMetadata;
      if (metadata != null) {
        jsonMetadata = jsonEncode(metadata);
      }

      await database.insertAuditEvent(
        AuditEventsCompanion.insert(
          id: uuid.v4(),
          eventType: eventType,
          employeeId: Value(employeeId),
          metadata: Value(jsonMetadata),
        ),
      );
    } catch (e) {
      throw DatabaseException('Failed to log audit event: ${e.toString()}');
    }
  }

  @override
  Future<List<AuditEvent>> getAuditEvents({
    AuditFilter? filter,
    AuditSort? sort,
    int? limit,
  }) async {
    try {
      var query = database.select(database.auditEvents);

      // Aplicar filtros
      if (filter != null) {
        query = query
          ..where((event) {
            final conditions = <Expression<bool>>[];

            if (filter.eventType != null) {
              final type = filter.eventType!;
              conditions.add(
                type.endsWith('_') ? event.eventType.like('$type%') : event.eventType.equals(type),
              );
            }

            if (filter.employeeId != null) {
              conditions.add(event.employeeId.equals(filter.employeeId!));
            }

            if (filter.startDate != null) {
              conditions.add(event.createdAt.isBiggerOrEqualValue(filter.startDate!));
            }

            if (filter.endDate != null) {
              conditions.add(event.createdAt.isSmallerOrEqualValue(filter.endDate!));
            }

            if (conditions.isEmpty) return const Constant(true);

            return conditions.reduce((value, element) => value & element);
          });
      }

      // Aplicar ordenamiento
      if (sort != null) {
        query = query
          ..orderBy([
            (event) {
              final column = _getSortColumn(event, sort.field);
              return OrderingTerm(
                expression: column,
                mode: sort.order == AuditSortOrder.ascending ? OrderingMode.asc : OrderingMode.desc,
              );
            }
          ]);
      }

      // Aplicar límite
      if (limit != null) {
        query = query..limit(limit);
      }

      final results = await query.get();

      // Convertir los metadatos JSON de vuelta a Map
      return results.map((event) => _convertJsonMetadata(event)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get audit events: ${e.toString()}');
    }
  }

  @override
  Future<AuditEvent?> getEventById(String id) async {
    try {
      final event = await (database.select(database.auditEvents)..where((event) => event.id.equals(id)))
          .getSingleOrNull();

      return event != null ? _convertJsonMetadata(event) : null;
    } catch (e) {
      throw DatabaseException('Failed to get audit event: ${e.toString()}');
    }
  }

  @override
  Future<int> getEventCount({AuditFilter? filter}) async {
    try {
      var query = database.selectOnly(database.auditEvents)
        ..addColumns([database.auditEvents.id.count()]);

      // Aplicar filtros (mismo código que en getAuditEvents)
      if (filter != null) {
        query = query
          ..where(
            _buildFilterExpression(database.auditEvents, filter),
          );
      }

      final result = await query.getSingle();
      return result.read(database.auditEvents.id.count()) ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to count audit events: ${e.toString()}');
    }
  }

  // Método auxiliar para convertir los metadatos JSON de vuelta a Map
  AuditEvent _convertJsonMetadata(AuditEvent event) {
    if (event.metadata != null) {
      try {
        final decoded = jsonDecode(event.metadata!);
        if (decoded is Map<String, dynamic>) {
          // Convertir de vuelta a JSON para mantener consistencia
          return event.copyWith(metadata: Value(jsonEncode(decoded)));
        }
      } catch (e) {
        // Si hay un error al decodificar, mantener el valor original
        return event;
      }
    }
    return event;
  }

  Expression<Object> _getSortColumn($AuditEventsTable event, AuditSortField field) {
    switch (field) {
      case AuditSortField.createdAt:
        return event.createdAt;
      case AuditSortField.eventType:
        return event.eventType;
      case AuditSortField.employeeId:
        return event.employeeId;
    }
  }

  Expression<bool> _buildFilterExpression($AuditEventsTable event, AuditFilter filter) {
    final conditions = <Expression<bool>>[];

    if (filter.eventType != null) {
      final type = filter.eventType!;
      conditions.add(
        type.endsWith('_') ? event.eventType.like('$type%') : event.eventType.equals(type),
      );
    }

    if (filter.employeeId != null) {
      conditions.add(event.employeeId.equals(filter.employeeId!));
    }

    if (filter.startDate != null) {
      conditions.add(event.createdAt.isBiggerOrEqualValue(filter.startDate!));
    }

    if (filter.endDate != null) {
      conditions.add(event.createdAt.isSmallerOrEqualValue(filter.endDate!));
    }

    if (conditions.isEmpty) return const Constant(true);

    return conditions.reduce((value, element) => value & element);
  }
}

import 'package:equatable/equatable.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';

abstract class AuditEvent extends Equatable {
  const AuditEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar eventos de auditoría
class LoadAuditEvents extends AuditEvent {
  final AuditFilter? filter;
  final AuditSort? sort;
  final int? limit;

  const LoadAuditEvents({
    this.filter,
    this.sort,
    this.limit,
  });

  @override
  List<Object?> get props => [filter, sort, limit];
}

/// Evento para aplicar filtros
class ApplyAuditFilter extends AuditEvent {
  final AuditFilter filter;

  const ApplyAuditFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Evento para cambiar ordenamiento
class ChangeAuditSort extends AuditEvent {
  final AuditSort sort;

  const ChangeAuditSort(this.sort);

  @override
  List<Object?> get props => [sort];
}

/// Evento para limpiar filtros
class ClearAuditFilters extends AuditEvent {
  const ClearAuditFilters();
}

/// Evento para refrescar la lista
class RefreshAuditEvents extends AuditEvent {
  const RefreshAuditEvents();
}

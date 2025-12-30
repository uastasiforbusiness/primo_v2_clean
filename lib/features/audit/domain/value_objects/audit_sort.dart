/// Opciones de ordenamiento para eventos de auditoría
enum AuditSortField {
  createdAt,
  eventType,
  employeeId,
}

enum AuditSortOrder {
  ascending,
  descending,
}

class AuditSort {
  final AuditSortField field;
  final AuditSortOrder order;

  const AuditSort({
    required this.field,
    required this.order,
  });

  // Default: más recientes primero
  static const defaultSort = AuditSort(
    field: AuditSortField.createdAt,
    order: AuditSortOrder.descending,
  );
}

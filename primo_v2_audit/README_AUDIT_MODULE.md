# Módulo de Auditoría - PRIMO V2

## 📋 Descripción

Módulo completo de auditoría que permite **registrar, listar, filtrar y ordenar** eventos del sistema siguiendo Clean Architecture.

## ✅ Funcionalidades Implementadas

### 1. Registrar Eventos ✅
- Registro inmutable de eventos en SQLite
- Transacciones ACID garantizadas
- Metadata opcional en formato JSON

### 2. Listar Eventos ✅
- Visualización de todos los eventos
- Paginación lista para implementar (límite configurable)
- Contador total de eventos

### 3. Filtrar Eventos ✅
- Por tipo de evento (event_type)
- Por empleado (employee_id)
- Por rango de fechas (start_date, end_date)
- Combinación de múltiples filtros (AND lógico)

### 4. Ordenar Eventos ✅
- Por fecha de creación (por defecto: más recientes primero)
- Por tipo de evento
- Por empleado
- Orden ascendente o descendente

## 🏗️ Arquitectura

```
lib/features/audit/
├── data/
│   ├── datasources/
│   │   └── audit_local_datasource.dart       # Adaptador Drift/SQLite
│   ├── models/
│   │   └── audit_event_model.dart            # DTO
│   └── repositories/
│       └── audit_repository_impl.dart        # Implementación del puerto
├── domain/
│   ├── entities/
│   │   └── audit_event_entity.dart           # Entidad de dominio
│   ├── repositories/
│   │   └── audit_repository.dart             # Puerto (interface)
│   ├── usecases/
│   │   ├── log_audit_event_usecase.dart      # Registrar eventos
│   │   └── get_audit_events_usecase.dart     # Obtener eventos
│   └── value_objects/
│       ├── audit_event_type.dart             # Tipos de eventos
│       ├── audit_filter.dart                 # Filtros
│       └── audit_sort.dart                   # Ordenamiento
└── presentation/
    ├── bloc/
    │   ├── audit_bloc.dart                   # Lógica de presentación
    │   ├── audit_event.dart                  # Eventos del BLoC
    │   └── audit_state.dart                  # Estados del BLoC
    ├── pages/
    │   └── audit_page.dart                   # Página principal
    └── widgets/
        └── audit_filter_dialog.dart          # Diálogo de filtros
```

## 🚀 Instalación

### Paso 1: Copiar Archivos

Copia toda la carpeta `lib/features/audit/` a tu proyecto:

```bash
cp -r lib/features/audit/ /tu/proyecto/lib/features/
```

### Paso 2: Actualizar Inyección de Dependencias

Abre `lib/di/injection_container.dart` y agrega los imports y registros del archivo `INJECTION_CONTAINER_UPDATE.dart`.

### Paso 3: Agregar Dependencia (si no la tienes)

En `pubspec.yaml`, asegúrate de tener:

```yaml
dependencies:
  intl: ^0.18.0  # Para formateo de fechas
```

Luego ejecuta:

```bash
flutter pub get
```

### Paso 4: Integrar en la Navegación

En tu `dashboard_page.dart` o donde quieras acceder, agrega un botón:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuditPage()),
    );
  },
  child: const Text('Ver Auditoría'),
)
```

## 📊 Uso

### Registrar un Evento

Desde cualquier parte del código:

```dart
import 'package:primo_v2/di/injection_container.dart';
import 'package:primo_v2/features/audit/domain/usecases/log_audit_event_usecase.dart';

// En tu código
final logAuditEvent = sl<LogAuditEventUseCase>();

await logAuditEvent(
  eventType: 'login_success',
  employeeId: 'admin-001',
  metadata: 'Login desde IP 192.168.1.1',
);
```

### Visualizar Eventos

Simplemente navega a `AuditPage`:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const AuditPage()),
);
```

### Filtrar Programáticamente

```dart
final filter = AuditFilter(
  eventType: 'clock_in',
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime.now(),
);

context.read<AuditBloc>().add(ApplyAuditFilter(filter));
```

## 🎨 UI Features

### Página Principal
- Lista de eventos con scroll infinito
- Indicador de filtros activos
- Contador total de eventos
- Botones de acción en AppBar

### Filtros
- Diálogo modal con campos de filtro
- Selector de fechas visual
- Botón "Limpiar Todo"
- Aplicación inmediata

### Ordenamiento
- Menú desplegable en AppBar
- Toggle automático de orden (asc/desc)
- Indicador visual del orden actual

### Eventos
- Cards con colores por tipo
- Iconos contextuales
- Formato de fecha legible
- Metadata expandible

## 🔧 Tipos de Eventos Predefinidos

```dart
// Autenticación
- login_success
- login_failed
- logout

// Turnos
- clock_in
- clock_out
- break_start
- break_end

// Empleados
- employee_created
- employee_updated
- employee_deleted

// Ventas (futuro)
- sale_created
- sale_cancelled
```

## 📝 Ejemplos de Uso

### Ejemplo 1: Registrar Login Exitoso

```dart
await sl<LogAuditEventUseCase>()(
  eventType: 'login_success',
  employeeId: employee.id,
  metadata: 'PIN verificado correctamente',
);
```

### Ejemplo 2: Registrar Clock-In

```dart
await sl<LogAuditEventUseCase>()(
  eventType: 'clock_in',
  employeeId: employee.id,
  metadata: 'Fondo inicial: \$${initialCash.toStringAsFixed(2)}',
);
```

### Ejemplo 3: Filtrar Eventos de un Empleado

```dart
final filter = AuditFilter(employeeId: 'admin-001');
context.read<AuditBloc>().add(ApplyAuditFilter(filter));
```

### Ejemplo 4: Ver Eventos de Hoy

```dart
final today = DateTime.now();
final startOfDay = DateTime(today.year, today.month, today.day);
final endOfDay = startOfDay.add(const Duration(days: 1));

final filter = AuditFilter(
  startDate: startOfDay,
  endDate: endOfDay,
);

context.read<AuditBloc>().add(ApplyAuditFilter(filter));
```

## 🧪 Testing

### Unit Tests (Ejemplo)

```dart
test('should log audit event successfully', () async {
  // Arrange
  final useCase = LogAuditEventUseCase(mockRepository);
  
  // Act
  final result = await useCase(
    eventType: 'test_event',
    employeeId: 'test-001',
  );
  
  // Assert
  expect(result.isRight(), true);
  verify(mockRepository.logEvent(
    eventType: 'test_event',
    employeeId: 'test-001',
  )).called(1);
});
```

## 🔒 Seguridad

- ✅ Eventos inmutables (no se pueden editar ni eliminar)
- ✅ Transacciones ACID garantizadas
- ✅ Type-safe con Drift
- ✅ Validación de inputs en casos de uso
- ✅ Manejo de errores con Either<Failure, Success>

## 📈 Futuras Mejoras

- [ ] Exportación a PDF/CSV
- [ ] Paginación real (infinite scroll)
- [ ] Búsqueda por texto completo
- [ ] Gráficos de actividad
- [ ] Notificaciones de eventos críticos
- [ ] Sincronización con backend

## 🐛 Troubleshooting

### Error: "AuditLocalDataSource not found"
**Solución**: Asegúrate de haber agregado los registros de DI correctamente.

### Error: "intl package not found"
**Solución**: Ejecuta `flutter pub get` después de agregar `intl` al pubspec.yaml.

### Los filtros no funcionan
**Solución**: Verifica que la tabla `AuditEvents` exista en tu base de datos Drift.

## 📚 Referencias

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)

---

**Desarrollado siguiendo los estándares de PRIMO V2**

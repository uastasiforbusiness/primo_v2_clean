# Plan de Reparación - Módulo de Auditoría

> Este documento contiene el plan completo para reparar el módulo de auditoría del proyecto PRIMO_V2

## 📊 Estado General

| Fase | Estado | Progreso |
|------|--------|----------|
| Fase 1: Nombre de archivo | ✅ Completado | 100% |
| Fase 2: Auditoría en empleados | ✅ Completado | 100% |
| Fase 3: AuditBloc completo | ⏳ Pendiente | 0% |
| Fase 4: totalCount correcto | ⏳ Pendiente | 0% |
| Fase 5: Inyección de dependencias | ⏳ Pendiente | 0% |

---

## 🔴 PROBLEMAS IDENTIFICADOS

### Problema #1: Nombre de Archivo Incorrecto (RESUELTO ✅)
- **Archivo**: `lib/features/audit/data/datasources/audit_local_datasource.dart`
- **Problema**: El archivo estaba nombrado como `audit_local_datasource.dart` (falta la "u" en "source")
- **Impacto**: Compilación fallida
- **Estado**: ✅ ARCHIVO RENOMBRADO A `audit_local_datasource.dart`

### Problema #2: Auditoría Deshabilitada en Empleados (RESUELTO ✅)
- **Archivo**: `lib/features/employees/data/datasources/employee_local_datasource_impl.dart`
- **Problema**: Los bloques de auditoría estaban TODO deshabilitados
- **Impacto**: Sin trazabilidad de empleados
- **Estado**: ✅ TODOS LOS EVENTOS HABILITADOS Y CORREGIDOS

### Problema #3: AuditBloc Incompleto (PENDIENTE ⏳)
- **Archivo**: `lib/features/audit/presentation/bloc/audit_bloc.dart`
- **Problema**: Solo tiene `GetAuditEventsUseCase`, falta `LogAuditEventUseCase`
- **Falta**: Evento `LogAuditEventRequested` y su handler
- **Estado**: ⏳ PENDIENTE

### Problema #4: totalCount Incorrecto (PENDIENTE ⏳)
- **Archivo**: `lib/features/audit/presentation/bloc/audit_bloc.dart`
- **Problema**: `totalCount` se calcula como `events.length` (solo eventos cargados, no el total)
- **Correcto**: Debería usar `getEventCount()` para obtener el total
- **Estado**: ⏳ PENDIENTE

### Problema #5: Inyección de Dependencias Incorrecta (PENDIENTE ⏳)
- **Archivo**: `lib/di/injection_container.dart`
- **Problema**: AuditBloc no recibe `logAuditEventUseCase`
- **Estado**: ⏳ PENDIENTE

---

## ✅ FASE 1: Arreglar Nombre de Archivo

### Estado: ✅ COMPLETADO

#### Cambios realizados:

1. ✅ **Archivo renombrado**
   - De: `audit_local_datasource.dart`
   - A: `audit_local_datasource.dart`

2. ✅ **Imports verificados**
   - `lib/di/injection_container.dart:8` ✅
   - `lib/features/audit/data/repositories/audit_repository_impl.dart:8` ✅

#### Verificación:
```bash
find lib/features/audit/data/datasources -name "*.dart"
# Resultado: audit_local_datasource.dart ✅
```

---

## ✅ FASE 2: Habilitar Auditoría en Empleados

### Estado: ✅ COMPLETADO

#### Cambios realizados:

1. ✅ **Auditoría corregida en clockIn** (líneas 163-170)
   - Event type: `clock_out` → `clock_in`
   - Metadata: Agregado `employeeId` y `hourlyRate`
   ```dart
   await database.insertAuditEvent(
     AuditEventsCompanion.insert(
       id: uuid.v4(),
       eventType: 'clock_in',
       employeeId: Value(employeeId),
       metadata: Value('Hourly rate: \$${hourlyRate ?? 0}'),
     ),
   );
   ```

2. ✅ **Auditoría en clockOut** (líneas 195-203)
   - Event type: `clock_out`
   - Metadata: Duración del turno en minutos
   ```dart
   await database.insertAuditEvent(
     AuditEventsCompanion.insert(
       id: uuid.v4(),
       eventType: 'clock_out',
       employeeId: Value(employeeId),
       metadata: Value(
         'Shift duration: ${DateTime.now().difference(activeShift.clockIn).inMinutes} min',
       ),
     ),
   );
   ```

3. ✅ **Auditoría en createEmployee** (líneas 46-53)
   - Event type: `employee_created`
   - Metadata: Rol del empleado

4. ✅ **Auditoría en updateEmployee** (líneas 105-112)
   - Event type: `employee_updated`
   - Metadata: Rol y si cambió el PIN

5. ✅ **Auditoría en deleteEmployee** (líneas 128-135)
   - Event type: `employee_deleted`
   - Metadata: "Soft delete"

#### Verificación:
```bash
flutter analyze lib/features/employees/data/datasources/employee_local_datasource_impl.dart
# Resultado: No issues found! ✅
```

---

## ⏳ FASE 3: Completar AuditBloc

### Estado: ⏳ PENDIENTE

#### Cambios necesarios:

**Archivo**: `lib/features/audit/presentation/bloc/audit_bloc.dart`

1. ⏳ **Agregar LogAuditEventUseCase como dependencia**
   ```dart
   class AuditBloc extends Bloc<AuditEvent, AuditState> {
     final GetAuditEventsUseCase getAuditEventsUseCase;
     final LogAuditEventUseCase logAuditEventUseCase;  // ⏳ AGREGAR
   ```

2. ⏳ **Agregar evento LogAuditEventRequested**
   ```dart
   // Crear en lib/features/audit/presentation/bloc/audit_event.dart
   class LogAuditEventRequested extends AuditEvent {
     final String eventType;
     final String? employeeId;
     final String? metadata;

     const LogAuditEventRequested({
       required this.eventType,
       this.employeeId,
       this.metadata,
     });

     @override
     List<Object?> get props => [eventType, employeeId, metadata];
   }
   ```

3. ⏳ **Agregar handler en constructor**
   ```dart
   AuditBloc({
     required this.getAuditEventsUseCase,
     required this.logAuditEventUseCase,  // ⏳ AGREGAR
   }) : super(const AuditInitial()) {
     on<LoadAuditEvents>(_onLoadAuditEvents);
     on<ApplyAuditFilter>(_onApplyAuditFilter);
     on<ChangeAuditSort>(_onChangeAuditSort);
     on<ClearAuditFilters>(_onClearAuditFilters);
     on<RefreshAuditEvents>(_onRefreshAuditEvents);
     on<LogAuditEventRequested>(_onLogAuditEvent);  // ⏳ AGREGAR
   }
   ```

4. ⏳ **Implementar handler _onLogAuditEvent**
   ```dart
   Future<void> _onLogAuditEvent(
     LogAuditEventRequested event,
     Emitter<AuditState> emit,
   ) async {
     final result = await logAuditEventUseCase(
       eventType: event.eventType,
       employeeId: event.employeeId,
       metadata: event.metadata,
     );

     result.fold(
       (failure) => emit(AuditError(failure.message)),
       (_) => null,  // No emitir nada si tiene éxito
     );
   }
   ```

---

## ⏳ FASE 4: Arreglar totalCount

### Estado: ⏳ PENDIENTE

#### Cambios necesarios:

**Archivo**: `lib/features/audit/presentation/bloc/audit_bloc.dart`

**Problema**: `totalCount` se calcula incorrectamente
```dart
// ❌ INCORRECTO (líneas 50, 76, 102, 128, 152)
totalCount: events.length,  // Solo cuenta eventos cargados, no el total
```

**Solución**: Usar `getEventCount()` para obtener el total real
```dart
// ✅ CORRECTO
final result = await getAuditEventsUseCase(...);

final countResult = await getAuditEventsUseCase.repository.getEventCount(
  filter: filter,
);

final totalCount = countResult.getOrElse(() => 0);

result.fold(
  (failure) => emit(AuditError(failure.message)),
  (events) => emit(
    AuditLoaded(
      events: events,
      currentFilter: _currentFilter,
      currentSort: _currentSort,
      totalCount: totalCount,  // ✅ CORREGIDO
    ),
  ),
);
```

**Métodos a actualizar**:
- ⏳ `_onLoadAuditEvents` (línea 25)
- ⏳ `_onApplyAuditFilter` (línea 56)
- ⏳ `_onChangeAuditSort` (línea 82)
- ⏳ `_onClearAuditFilters` (línea 108)
- ⏳ `_onRefreshAuditEvents` (línea 134)

---

## ⏳ FASE 5: Actualizar Inyección de Dependencias

### Estado: ⏳ PENDIENTE

#### Cambios necesarios:

**Archivo**: `lib/di/injection_container.dart`

**Código actual** (línea 145-149):
```dart
// ❌ INCORRECTO
sl.registerFactory(
  () => AuditBloc(
    getAuditEventsUseCase: sl(),
    // ❌ FALTA: logAuditEventUseCase
  ),
);
```

**Código corregido**:
```dart
// ✅ CORRECTO
sl.registerFactory(
  () => AuditBloc(
    getAuditEventsUseCase: sl(),
    logAuditEventUseCase: sl(),  // ✅ AGREGAR
  ),
);
```

**Nota**: `LogAuditEventUseCase` ya está registrado (línea 142)
```dart
sl.registerLazySingleton(() => LogAuditEventUseCase(sl()));
```

---

## 📋 MATRIZ DE PRIORIDADES

| Problema | Prioridad | Estado | Complejidad |
|----------|-----------|--------|-------------|
| #1: Nombre de archivo | 🔴 CRÍTICA | ✅ COMPLETADO | Baja |
| #2: Auditoría deshabilitada | 🔴 CRÍTICA | ✅ COMPLETADO | Media |
| #3: AuditBloc incompleto | 🟡 ALTA | ⏳ PENDIENTE | Media |
| #4: totalCount incorrecto | 🟡 ALTA | ⏳ PENDIENTE | Media |
| #5: DI incorrecta | 🟡 ALTA | ⏳ PENDIENTE | Baja |

---

## 🎯 RESULTADO ESPERADO

Después de completar todas las fases:

✅ **Fase 1**: El código compila correctamente
✅ **Fase 2**: Trazabilidad completa de operaciones de empleados
✅ **Fase 3**: AuditBloc puede registrar eventos desde la UI
✅ **Fase 4**: Paginación correcta con totalCount real
✅ **Fase 5**: Inyección de dependencias completa

---

## 🚀 PRÓXIMOS PASOS

Para continuar con las fases pendientes:

1. **Implementar Fase 3** (AuditBloc completo)
   - Agregar `LogAuditEventUseCase` al BLoC
   - Crear evento `LogAuditEventRequested`
   - Implementar handler

2. **Implementar Fase 4** (totalCount correcto)
   - Actualizar los 5 handlers de eventos
   - Usar `getEventCount()` para el total real

3. **Implementar Fase 5** (DI correcta)
   - Agregar `logAuditEventUseCase` al AuditBloc

---

## 📝 NOTAS

- Las fases 1 y 2 fueron completadas exitosamente
- La auditoría en empleados ahora registra todos los eventos:
  - `employee_created`
  - `employee_updated`
  - `employee_deleted`
  - `clock_in`
  - `clock_out`
- Todos los eventos se registran en transacciones ACID
- El código compila sin errores después de las fases 1 y 2

---

*Última actualización: 2025-01-03*

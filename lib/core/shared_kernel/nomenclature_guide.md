# 📖 Guía de Nomenclatura - PRIMO V2

## 🎯 Objetivo
Establecer un vocabulario único y consistente para todos los componentes del sistema para evitar confusiones y mejorar la mantenibilidad.

## 📋 Reglas Generales

### 1. Eventos (BLoC)
- **Formato:** `[Acción][Entidad][Sufijo]`
- **Ejemplos:**
  - `LoginWithPinRequested` ✅ (Acción: Login, Entidad: Pin, Sufijo: Requested)
  - `LoadActiveShift` ✅ (Acción: Load, Entidad: ActiveShift)
  - `ClockInRequested` ✅ (Acción: ClockIn, Sufijo: Requested)
  - `StartBreakRequested` ✅ (Acción: Start, Entidad: Break, Sufijo: Requested)

### 2. Estados (BLoC)
- **Formato:** `[Entidad][Estado]` o `[Estado][Entidad]`
- **Ejemplos:**
  - `AuthAuthenticated` ✅ (Entidad: Auth, Estado: Authenticated)
  - `ShiftActive` ✅ (Entidad: Shift, Estado: Active)
  - `ShiftOnBreak` ✅ (Entidad: Shift, Estado: OnBreak)
  - `AuthError` ✅ (Estado: Error, Entidad: Auth)

### 3. Casos de Uso
- **Formato:** `[Acción][Entidad]UseCase`
- **Ejemplos:**
  - `LoginWithPinUseCase` ✅
  - `ClockInUseCase` ✅
  - `StartBreakUseCase` ✅
  - `GetActiveShiftUseCase` ✅

### 4. Repositorios
- **Formato:** `[Entidad]Repository`
- **Ejemplos:**
  - `AuthRepository` ✅
  - `ShiftRepository` ✅
  - `EmployeeRepository` ✅

### 5. Data Sources
- **Formato:** `[Entidad][Tipo]DataSource`
- **Ejemplos:**
  - `AuthLocalDataSource` ✅
  - `EmployeeLocalDataSource` ✅
  - `ShiftLocalDataSource` ✅

## 🔧 Patrones de Navegación

### 1. GoRouter - Redirecciones
- **Siempre** verificar el estado actual antes de redirigir
- **Evitar** condiciones de carrera usando `Future.microtask()` cuando sea necesario
- **Priorizar** estados estables sobre estados de carga

### 2. Manejo de Estados Asincrónicos
- **Patrón recomendado:**
```dart
// 1. Emitir estado de carga
emit(LoadingState());

// 2. Realizar operación asincrónica
final result = await useCase();

// 3. Emitir resultado
result.fold(
  (failure) => emit(ErrorState(failure)),
  (success) => emit(SuccessState(success)),
);
```

## ⚠️ Antipatrones a Evitar

### 1. Condiciones de Carrera
```dart
// ❌ MAL: Disparar eventos que dependen de otros sin sincronización
context.read<BlocA>().add(EventA());
context.read<BlocB>().add(EventB()); // Depende de EventA

// ✅ BIEN: Usar Future.microtask para sincronización
context.read<BlocA>().add(EventA());
Future.microtask(() {
  context.read<BlocB>().add(EventB());
});
```

### 2. Nomenclatura Inconsistente
```dart
// ❌ MAL: Mezclar estilos
class GetUserData {} // get + data
class FetchEmployee {} // fetch
class LoadShiftInfo {} // load + info

// ✅ BIEN: Usar estilo consistente
class GetUser {} // get
class GetEmployee {} // get
class GetShift {} // get
```

### 3. Lógica de Navegación Compleja en UI
```dart
// ❌ MAL: Lógica de navegación en widgets
if (state is Authenticated) {
  Navigator.push(context, ...);
}

// ✅ BIEN: Delegar navegación al router
// En AppRouter.redirect():
if (state is Authenticated && location == '/login') {
  return '/dashboard';
}
```

## 📚 Glosario de Términos

| Término | Significado | Ejemplo |
|---------|-------------|---------|
| **Requested** | Evento que solicita una acción | `LoginRequested` |
| **Loaded** | Estado después de cargar datos | `ShiftLoaded` |
| **Active** | Estado activo/actual | `ShiftActive` |
| **Inactive** | Estado inactivo | `ShiftInactive` |
| **Error** | Estado de error | `AuthError` |
| **Initial** | Estado inicial | `AuthInitial` |
| **Loading** | Estado de carga | `AuthLoading` |

## 🎯 Buenas Prácticas

1. **Siempre** documentar nuevos componentes con su propósito y uso
2. **Usar** el sistema de nomenclatura establecido
3. **Evitar** abreviaturas a menos que sean estándar del dominio
4. **Mantener** consistencia en todo el código
5. **Revisar** el código con esta guía antes de hacer commit
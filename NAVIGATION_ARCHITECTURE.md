# 🏗️ Arquitectura de Navegación para PRIMO V2

## 📅 Fecha
28 de diciembre de 2025

## 🎯 Objetivo
Diseñar un sistema de navegación profesional para un POS offline-first que respete la separación de conceptos (Auth vs Shift) y mantenga la arquitectura limpia.

---

## 🗺️ Mapa de Rutas Conceptual

### 🔒 Rutas Base (No Autenticadas)
- `/` - Splash/Bootstrap (validación de integridad de base de datos)
- `/login` - Autenticación por PIN numérico
- `/error` - Pantalla de error genérico
- `/forbidden` - Acceso denegado por permisos insuficientes

### 🛡️ Rutas Autenticadas (Protegidas por ShellRoute)
```
/dashboard
├── /home              # Vista principal del dashboard
├── /clock-in          # Inicio de turno (fondo de caja)
├── /active-shift      # Turno activo (operaciones)
└── /break             # Pausa activa
```

### 👑 Rutas de Administración (Solo ADMIN)
```
/dashboard
├── /employees         # Lista de empleados (CRUD)
├── /employees/:id     # Detalle/edición de empleado
└── /settings          # Configuración del sistema
```

### 🚧 Rutas Futuras (Preparadas para expansión)
```
/dashboard
├── /audit             # Módulo de auditoría (futuro)
└── /sales             # Módulo de ventas (futuro)
```

---

## 📐 Jerarquía de Navegación

```mermaid
graph TD
    A[AppRouter] --> B[/]
    A --> C[/login]
    A --> D[/error]
    A --> E[/forbidden]
    A --> F[ShellRoute: /dashboard]
    F --> F1[/home]
    F --> F2[/clock-in]
    F --> F3[/active-shift]
    F --> F4[/break]
    F --> F5[/employees]
    F --> F6[/employees/:id]
    F --> F7[/settings]
    F --> F8[/audit]
    F --> F9[/sales]
```

---

## 🛡️ Sistema de Protección y Redirecciones

### 🔄 Lógica de Redirección por Estado

#### 1. Estado de Autenticación
- **No autenticado** → Redirigir a `/login` (excepto si ya está en `/login`)
- **Autenticado en `/login`** → Redirigir a `/dashboard`

#### 2. Estado de Turno
- **Autenticado sin turno activo** → Redirigir a `/dashboard/clock-in`
- **Turno activo** → Permitir acceso a `/dashboard/active-shift`
- **En pausa** → Redirigir a `/dashboard/break`

#### 3. Control por Roles
- **EMPLOYEE** intenta acceder a rutas ADMIN → Redirigir a `/forbidden`
- **ADMIN** tiene acceso completo a todas las rutas

### 📌 Implementación de Guards

```dart
// Ejemplo conceptual de implementación en GoRouter
redirect: (context, state) {
  final authState = context.read<AuthBloc>().state;
  final shiftState = context.read<ShiftBloc>().state;
  
  // Guard 1: Autenticación requerida
  if (authState is! AuthAuthenticated && 
      !state.location.startsWith('/login') && 
      state.location != '/') {
    return '/login';
  }
  
  // Guard 2: Usuario autenticado no debe ver login
  if (authState is AuthAuthenticated && 
      state.location == '/login') {
    return '/dashboard';
  }
  
  // Guard 3: Turno requerido para operaciones
  if (authState is AuthAuthenticated) {
    if (shiftState is ShiftInactive && 
        !state.location.startsWith('/dashboard/clock-in')) {
      return '/dashboard/clock-in';
    }
    
    if (shiftState is ShiftActive && 
        state.location == '/dashboard/clock-in') {
      return '/dashboard/active-shift';
    }
  }
  
  // Guard 4: Control de acceso por rol
  if (state.location.startsWith('/dashboard/employees') ||
      state.location.startsWith('/dashboard/settings')) {
    final employee = (authState as AuthAuthenticated).employee;
    if (employee.role != Role.ADMIN) {
      return '/forbidden';
    }
  }
  
  return null; // No redirección
}
```

---

## 🔄 Separación de Responsabilidades entre BLoCs

### AuthBloc
- **Responsabilidad**: Gestionar el estado de autenticación
- **Ámbito**: Todas las rutas protegidas
- **Prohibido**:
  - Conocer el estado de turnos
  - Acceder a lógica de empleados
  - Mutar base de datos

### ShiftBloc
- **Responsabilidad**: Gestionar el estado de turnos
- **Ámbito**: Rutas de dashboard relacionadas con operaciones
- **Prohibido**:
  - Conocer el estado de autenticación
  - Acceder a lógica de autenticación
  - Mutar base de datos desde eventos de navegación

### EmployeeBloc
- **Responsabilidad**: Gestionar CRUD de empleados
- **Ámbito**: Solo rutas de administración (`/employees`)
- **Prohibido**:
  - Conocer estado de navegación
  - Acceder a lógica de turnos
  - Mutar base de datos fuera de casos de uso

---

## 🚫 Matriz de Acceso por Rol

| Ruta                     | ADMIN | EMPLOYEE | Descripción                          |
|--------------------------|-------|----------|--------------------------------------|
| `/`                      | ✅    | ✅       | Splash/Bootstrap                     |
| `/login`                 | ✅    | ✅       | Autenticación                        |
| `/dashboard/home`        | ✅    | ✅       | Vista principal                      |
| `/dashboard/clock-in`    | ✅    | ✅       | Inicio de turno                      |
| `/dashboard/active-shift`| ✅    | ✅       | Turno activo                         |
| `/dashboard/break`       | ✅    | ✅       | Pausa activa                         |
| `/dashboard/employees`   | ✅    | ❌       | Lista de empleados                   |
| `/dashboard/employees/:id`| ✅   | ❌       | Detalle de empleado                  |
| `/dashboard/settings`    | ✅    | ❌       | Configuración                        |
| `/dashboard/audit`       | ✅    | ❌       | Auditoría (futuro)                   |
| `/dashboard/sales`       | ✅    | ✅       | Ventas (futuro)                      |
| `/error`                 | ✅    | ✅       | Error genérico                       |
| `/forbidden`             | ✅    | ✅       | Acceso denegado                      |

---

## ⚠️ Errores Críticos a Evitar

### 🔴 Anti-Patrones de Arquitectura

1. **Mezclar Auth con Shift**:
   - ❌ `AuthBloc` no debe conocer `ShiftState`
   - ✅ Usar redirecciones basadas en estados independientes

2. **Navegación Imperativa**:
   - ❌ `Navigator.push(context, ...)`
   - ✅ Usar solo GoRouter declarativo

3. **Mutaciones desde Routing**:
   - ❌ Acceder a BD desde `redirect`
   - ✅ Solo lecturas para validación

4. **Asumir Conexión**:
   - ❌ Llamadas a API en guards
   - ✅ Todo debe funcionar offline

5. **Acoplamiento con UI**:
   - ❌ Lógica de routing en widgets
   - ✅ Centralizar en `AppRouter`

6. **Estados Intermedios**:
   - ❌ Ignorar loading/error states
   - ✅ Manejar todos los estados posibles

### 🟡 Problemas Comunes de Implementación

1. **ShellRoute mal configurado**:
   - Asegurar que el layout se mantenga
   - No recargar componentes innecesarios

2. **Redirecciones infinitas**:
   - Validar condiciones cuidadosamente
   - Usar logging para debug

3. **Inyección de dependencias**:
   - Asegurar BLoCs disponibles en todos los niveles
   - Usar `MultiBlocProvider` si necesario

4. **Manejo de parámetros**:
   - Validar parámetros de ruta (`:id`)
   - Mostrar error si inválidos

---

## 🏛️ Recomendaciones de Estructura de Código

### 📁 Estructura de Archivos

```
lib/
├── core/
│   └── router/               # Solo lógica de routing
│       ├── app_router.dart    # Configuración principal
│       └── route_guards.dart  # Lógica de guards (opcional)
├── features/
│   ├── auth/                 # Solo autenticación
│   │   └── presentation/
│   │       ├── bloc/         # AuthBloc
│   │       └── pages/        # Login, etc.
│   ├── shifts/               # Solo turnos
│   │   └── presentation/
│   │       ├── bloc/         # ShiftBloc
│   │       └── pages/        # ClockIn, Dashboard, etc.
│   └── employees/            # Solo empleados
│       └── presentation/
│           ├── bloc/         # EmployeeBloc
│           └── pages/        # Employees, EmployeeDetail
└── main.dart                 # Inicialización
```

### 🔧 Inyección de Dependencias

```dart
// En main.dart o injection_container.dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
    BlocProvider<ShiftBloc>(create: (_) => sl<ShiftBloc>()),
    // EmployeeBloc solo donde se necesite
  ],
  child: MaterialApp.router(
    routerConfig: AppRouter.router,
  ),
)
```

### 🧪 Estrategia de Testing

1. **Pruebas de Navegación**:
   - Verificar cada ruta con diferentes estados
   - Probar redirecciones en todos los escenarios

2. **Pruebas de Guards**:
   - Validar acceso por rol
   - Probar estados de autenticación y turno

3. **Pruebas de Integración**:
   - Flujo completo: login → clock-in → operaciones
   - Manejo de errores y estados intermedios

---

## 🎯 Decisiones de Diseño Justificadas

### 1. ShellRoute para Dashboard
**Razón**: Mantener estructura visual consistente (sidebar, header) mientras se navega entre secciones.
**Beneficio**: Mejor experiencia de usuario y rendimiento (no se recarga el layout).

### 2. Rutas por Estado
**Razón**: Cada estado de la aplicación tiene una ruta específica.
**Beneficio**: Facilita el manejo de UI y lógica de negocio.

### 3. Separación Estricta de Conceptos
**Razón**: Auth ≠ Shift ≠ Employee son dominios diferentes.
**Beneficio**: Código más mantenible y fácil de testear.

### 4. Rutas Reservadas para Futuro
**Razón**: Preparar la estructura para módulos no implementados.
**Beneficio**: Expansión sin refactorización mayor.

### 5. Diseño Offline-First
**Razón**: POS debe funcionar sin conexión.
**Beneficio**: Experiencia de usuario consistente.

---

## 🚀 Plan de Implementación

### Fase 1: Configuración Inicial
1. Añadir `go_router` a `pubspec.yaml`
2. Crear estructura base de `AppRouter`
3. Configurar ShellRoute para dashboard

### Fase 2: Implementación de Guards
1. Implementar lógica de redirección por autenticación
2. Añadir guards para estado de turno
3. Configurar control de acceso por rol

### Fase 3: Integración con BLoCs
1. Asegurar BLoCs disponibles en routing
2. Conectar estados con redirecciones
3. Probar flujo completo

### Fase 4: Testing y Validación
1. Crear pruebas unitarias para guards
2. Probar navegación en diferentes estados
3. Validar manejo de errores

### Fase 5: Documentación
1. Documentar API de navegación
2. Crear guía para desarrolladores
3. Actualizar arquitectura general

---

## 📝 Notas Finales

### 🔒 Seguridad
- Nunca exponer información sensible en rutas
- Validar todos los parámetros de ruta
- Usar HTTPS en producción (aunque sea offline-first)

### 🔄 Mantenibilidad
- Mantener routing independiente de UI
- Documentar cada guard y redirección
- Usar nombres de rutas consistentes

### 📊 Métricas de Éxito
- 100% de rutas protegidas correctamente
- 0 navegación imperativa
- 0 acoplamiento entre dominios
- 100% funcionalidad offline

---

**Documento generado por**: Mistral Vibe
**Rol**: Lead Engineer - Arquitectura Flutter
**Proyecto**: PRIMO V2 - Sistema POS Profesional
**Fecha**: 28 de diciembre de 2025
# PRIMO V2 - Sistema POS

Sistema POS completo con autenticación PIN, gestión de empleados y control de turnos.

## ✅ Características Implementadas

### Módulo de Autenticación
- ✅ Login con PIN (4 dígitos)
- ✅ Bloqueo temporal tras 3 intentos fallidos
- ✅ Clock-In/Clock-Out con registro de caja
- ✅ Gestión de pausas (breaks)
- ✅ Bloqueo de pantalla (sesión ≠ turno)
- ✅ Eventos de auditoría

### Base de Datos (Drift/SQLite)
- ✅ Tablas: Employees, Shifts, Breaks, CashRegisters, AuditEvents
- ✅ Migraciones versionadas
- ✅ Seeds iniciales (Admin + Caja por defecto)
- ✅ Transacciones ACID

### Arquitectura
- ✅ Clean Architecture / Hexagonal
- ✅ BLoC para gestión de estado
- ✅ Value Objects (Pin, Role, Money)
- ✅ Inyección de dependencias (GetIt)
- ✅ Separación estricta de capas

## 🚀 Cómo Ejecutar

### 1. Instalar Dependencias

```bash
flutter pub get
```

### 2. Generar Código de Drift

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Ejecutar la Aplicación

```bash
flutter run
```

## 🔐 Credenciales de Prueba

**Usuario Admin por defecto:**
- PIN: `1234`
- Rol: ADMIN
- Nombre: Administrador Sistema

## 📁 Estructura del Proyecto

```
lib/
├── core/
│   ├── error/              # Failures y Exceptions
│   ├── utils/              # Utilidades
│   └── shared_kernel/      # Value Objects (Pin, Role, Money)
├── di/                     # Inyección de dependencias
└── features/
    ├── auth/               # Autenticación y Time Clock
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── employees/          # Gestión de empleados
    │   └── presentation/
    └── database/           # Drift/SQLite
        └── data/
```

## 🎯 Flujo de Uso

1. **Login**: Ingresa el PIN en el numpad
2. **Clock-In**: Si no tienes turno activo, ingresa el fondo de caja inicial
3. **Dashboard**: Accede a las funciones del sistema según tu rol
4. **Pausas**: Inicia/termina breaks sin cerrar el turno
5. **Clock-Out**: Cierra el turno ingresando el monto final de caja

## 🔧 Próximos Módulos

- [ ] CRUD completo de Employees
- [ ] Módulo de Ventas
- [ ] Módulo de Stock
- [ ] Reportes y Auditoría
- [ ] Sincronización con Backend
- [ ] Integración de Hardware (impresoras, cajón)

## 📝 Notas Técnicas

### Sesión vs Turno

- **Sesión**: Estado temporal de la UI, se pierde al bloquear pantalla
- **Turno**: Estado financiero persistente, solo se cierra con Clock-Out

### Seguridad

- PINs hasheados con SHA-256
- Bloqueo automático tras intentos fallidos
- Todos los eventos críticos son auditados

### Base de Datos

- SQLite con Drift para type-safety
- Transacciones obligatorias para operaciones financieras
- Soft delete para empleados (mantiene integridad histórica)

## 🛠️ Tecnologías

- **Flutter**: Framework UI
- **BLoC**: Gestión de estado
- **Drift**: ORM para SQLite
- **GetIt**: Inyección de dependencias
- **Dartz**: Programación funcional (Either)
- **Equatable**: Comparación de objetos

---

**Desarrollado siguiendo principios de Clean Architecture y Domain-Driven Design**

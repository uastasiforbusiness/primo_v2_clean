Aquí tienes el contenido limpio y consolidado para tu archivo `CLAUDE.md`. Copia y pega esto reemplazando todo lo que haya actualmente en ese archivo.

```markdown
# CLAUDE.md – PRIMO_V2 Master Context

Este archivo es la FUENTE ÚNICA DE VERDAD para el desarrollo en PRIMO_V2.

## 1. Visión General del Proyecto
Sistema POS (Point of Sale) Offline-First construido con Flutter.
- **Arquitectura:** Clean Architecture + Hexagonal.
- **Estado:** BLoC (Event → State) con `Equatable`.
- **Base de Datos:** Drift (SQLite) con transacciones ACID obligatorias.
- **Filosofía:** Integridad financiera > Velocidad de desarrollo.

**Credenciales Admin (Default):**
- PIN: `1234` | ID: `admin-001` | Rol: `ADMIN`

---

## 2. Las 6 Reglas de Oro (INNEGOCIABLES)

Si rompes una de estas reglas, el código es inválido.

1.  **La Regla del Import Sagrado:**
    * `Domain` **NUNCA** importa `Data`, `Presentation`, `Flutter_Bloc` ni `Drift`.
    * `Domain` debe ser puro Dart.

2.  **La Regla del Dinero (ACID):**
    * Toda operación financiera (Clock-In, Ventas, Breaks, Clock-Out) o creación crítica **DEBE** usar `database.transaction(() async { ... })`.

3.  **La Regla del BLoC Único:**
    * Un BLoC = Una Responsabilidad.
    * ⛔ `AuthBloc` manejando Turnos.
    * ✅ `AuthBloc` (Sesión) vs `ShiftBloc` (Turno Laboral).

4.  **La Regla del Camino Sagrado (Debugging):**
    * Orden estricto de análisis:
        1. `UI` (Síntoma)
        2. `BLoC` (Estado)
        3. `UseCase` (Lógica)
        4. `Repository` (Contrato)
        5. `Data` (Implementación/BD)
    * ⛔ Prohibido arreglar lógica de negocio en la UI.

5.  **La Regla del Tipado Fuerte:**
    * ⛔ Prohibido usar `dynamic`.
    * Usa `Either<Failure, T>` para el manejo de errores.

6.  **La Regla de Metadatos Estructurados:**
    * Todos los metadatos de auditoría deben ser estructurados como `Map<String, dynamic>` que se convierte a JSON antes de almacenarse.
    * Esto asegura que todos los eventos de auditoría tengan metadatos consistentes y estructurados.
    * ⛔ Prohibido almacenar metadatos como cadenas arbitrarias.
    * ✅ Todos los `logEvent` deben recibir metadatos como objetos estructurados.

---

## 3. Comandos de Desarrollo

**Gestión de Dependencias y Base de Datos:**
```bash
# Instalar dependencias
flutter pub get

# Generar código (Drift/Freezed/Json) - EJECUTAR SIEMPRE QUE CAMBIES BD O ESTADOS
flutter pub run build_runner build --delete-conflicting-outputs

```

**Testing y Calidad:**

```bash
flutter test
flutter analyze

```

**Verificación de Arquitectura (Detectar violaciones):**

```bash
# Si este comando devuelve algo, la arquitectura está ROTA:
grep -r "import.*features.*data" lib/features/*/domain/
grep -r "import.*features.*presentation" lib/features/*/domain/

```

---

## 4. Guía de Implementación (Workflow)

Para añadir una nueva funcionalidad (ej. "Ventas"), sigue ESTE orden estricto. No avances al siguiente paso sin terminar el anterior.

### Fase 1: El "Qué" (Domain Layer)

1. **Entity:** `features/ventas/domain/entities/sale.dart` (Objeto de negocio puro).
2. **Repository Interface:** `features/ventas/domain/repositories/sale_repository.dart` (Contrato abstracto).
3. **Use Cases:** `features/ventas/domain/usecases/process_sale.dart` (Reglas de negocio: "¿Hay stock?", "¿Caja abierta?").

### Fase 2: El "Cómo" (Data Layer)

4. **Drift Table:** `features/database/data/tables/sales.dart` (Definición SQL).
5. **Model:** (Generado automáticamente por Drift).
6. **Repository Impl:** `features/ventas/data/repositories/sale_repository_impl.dart` (Implementa la interfaz, usa transacciones).

### Fase 3: El "Cuándo" (Presentation Layer)

7. **BLoC Events/States:** Define qué pasa y qué se muestra.
8. **BLoC Logic:** Conecta Eventos con UseCases.
9. **Page/Widgets:** UI tonta que solo escucha estados y dispara eventos.

---

## 5. Estándares de Código

* **Value Objects:** Usa `Money`, `Pin`, `Role` (en `core/shared_kernel`) en lugar de `double` o `String` primitivos.
* **Errores:** Nunca captures excepciones silenciosamente. Conviértelas en `Failure` y retórnalas con `Left()`.
* **Logging:** Usa `logger.d()` o `logger.e()`. Nunca `print()`.
* **Inyección:** Registra todo en `lib/di/injection_container.dart`.
* BLoCs → `registerFactory`
* UseCases/Repos → `registerLazySingleton`



---

## 6. Distinción Crítica: Sesión vs Turno

* **Sesión (AuthBloc):** ¿Quién eres? (Login/Logout). Se pierde al cerrar la app.
* **Turno (ShiftBloc):** ¿Estás trabajando? (Clock-In/Clock-Out). Persiste en BD hasta que cierres caja.
* *Nota:* Puedes estar logueado (Sesión) sin estar trabajando (Turno inactivo).

```

```
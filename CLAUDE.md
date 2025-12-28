# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PRIMO_V2 is a POS (Point of Sale) system built with Flutter, implementing Clean Architecture/Hexagonal Architecture with BLoC state management and Drift (SQLite) for local persistence. The system prioritizes offline-first operation, financial transaction integrity, and strict separation of concerns.

**Default Admin Credentials:**
- PIN: `1234`
- Role: ADMIN
- Employee ID: `admin-001`

## Non-Negotiable Principles

1. **Architecture is non-negotiable:**
   - Hexagonal/Clean Architecture
   - Deterministic BLoC pattern (Event → State)

2. **The goal of debugging is NOT to "make it work", but to:**
   - Identify the root cause
   - Fix it in the correct layer
   - Preserve scalability and auditability

3. **Every solution must be:**
   - Explainable
   - Testable
   - Sustainable over time

**Core Philosophy:**
> "A bug fixed without understanding it is a bug that will return."

PRIMO_V2 prioritizes clarity, control, and traceability over improvised speed.

## Development Commands

### Install Dependencies
```bash
flutter pub get
```

### Code Generation (Drift)
Required after modifying any Drift table definitions or queries:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Application
```bash
flutter run
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests with coverage
flutter test --coverage
```

### Linting
```bash
flutter analyze
```

## Mandatory Debugging Protocol

Before proposing ANY solution, you MUST explicitly identify:

1. **Observable Symptom**
   - What the user sees
   - Which state is failing

2. **Affected Layer**
   - UI / BLoC / Domain / Data

3. **Probable Root Cause**
   - Incorrectly emitted state
   - Mishandled event
   - Inconsistent persistence
   - Business rule violation

**No solution is valid without this prior analysis.**

## Architecture - Layer Analysis Order (MANDATORY)

ALL debugging and analysis MUST follow this exact order:
```
UI (Widgets)
  ↓
BLoC (State Management)
  ↓
Use Case / Business Rule
  ↓
Repository Interface (Domain Contract)
  ↓
Repository Implementation (Data Layer)
  ↓
DataSource (Drift/SQLite)
```

### Explicit Prohibitions
- Skipping layers
- Fixing bugs in the UI layer
- Moving business logic "to make it pass"
- Touching `AuthBloc` to fix employee management issues
- Adding business logic in widgets
- Using `print()` (use `logger` package only)
- Using `dynamic` types
- Introducing patches without causal justification

### Permitted Actions
- Adjusting logic in BLoC
- Correcting repository contracts
- Adding business rule validations
- Improving state management

## AI-Specific Requirements

When proposing a solution, you MUST:

1. Explain **why the bug occurs**
2. Explain **why this solution is correct**
3. Explain **which alternative was discarded and why**
4. Respect the existing architecture (do not reinvent it)

If you cannot fulfill these points → **the solution is invalid**.

## Solution Approval Criteria

A solution is ONLY considered correct if it:
- Respects the architecture
- Does not introduce new responsibilities
- Scales to future modules (sales, auditing, synchronization)
- Does not break the offline-first approach

## Clean Architecture Boundaries

**Domain Layer** (`lib/features/*/domain/`):
- Contains business logic, entities, repository interfaces
- MUST NOT depend on any infrastructure (Drift, UI, external packages)
- Uses `Either<Failure, T>` from `dartz` for error handling
- Defines contracts that outer layers implement

**Data Layer** (`lib/features/*/data/`):
- Implements repository interfaces from domain
- Contains DataSources (Drift interactions)
- Handles data transformation between Drift models and domain entities
- Only layer that directly interacts with database

**Presentation Layer** (`lib/features/*/presentation/`):
- BLoC for state management (one BLoC = one responsibility)
- Widgets consume BLoC states
- NEVER contains business logic
- Emits events to BLoC, renders states

## Code Contract (Technical Rules)

- **Strict typing mandatory** - no `dynamic`
- **Immutable states** - use `Equatable`
- **One BLoC = one responsibility**
- **Drift only lives in `data/`**
- **Domain does not know infrastructure**
- **Errors must be explicit** (not silenced)

## Value Objects

Located in `lib/core/shared_kernel/`:

- **Pin**: Validates 4-digit numeric PIN, handles SHA-256 hashing
  - Use `Pin.fromPlainText()` for user input
  - Use `Pin.fromHash()` for stored values
  - Use `.toHash()` to get SHA-256 hash
  - Use `.verify(plainText)` to check PIN

- **Money**: Immutable monetary values with validation
  - NEVER use raw `double` for money
  - Use `Money.fromDouble()` for user input
  - Use `Money.zero()` for initialization
  - Prevents negative amounts through operators

- **Role**: Employee role enumeration (in domain/entities)

## BLoC Pattern Conventions

**Event Naming:**
- Use past tense or imperative: `LoginRequested`, `ClockInRequested`
- One event = one user action

**State Naming:**
- Use present tense: `AuthLoading`, `AuthAuthenticated`, `AuthError`
- Always extend base state with `Equatable`
- Include all data needed for UI rendering

**BLoC Rules:**
- States MUST be immutable
- Use `emit()` NEVER direct state mutation
- Handle ALL events explicitly
- Use `bloc_concurrency` transformers for async events

## Dependency Injection (GetIt)

Located in `lib/di/injection_container.dart`:

**Registration Types:**
- `registerLazySingleton`: Database, repositories, use cases, data sources
- `registerFactory`: BLoCs (new instance per request)
- `registerSingleton`: Use sparingly (core utilities only)

**Access Pattern:**
```dart
import 'package:primo_v2/di/injection_container.dart';

final bloc = sl<AuthBloc>();
final useCase = sl<LoginWithPinUseCase>();
```

**Adding New Dependencies:**
1. Register in appropriate feature section
2. Follow dependency order: DataSource → Repository → UseCase → BLoC
3. Use `sl()` to inject dependencies

## Database (Drift)

**Schema Location:** `lib/features/database/data/app_database.dart`

**Tables:**
- `Employees`: User accounts with PIN hashes
- `CashRegisters`: Available POS terminals
- `Shifts`: Work sessions with cash tracking
- `Breaks`: Pause periods within shifts
- `AuditEvents`: System event logging

**Transaction Rules:**
- ALL financial operations (clock-in, clock-out, cash changes) MUST use transactions
- Use `transaction(() async { ... })` in repository implementations
- Shifts and cash movements are ACID-compliant

**Queries:**
- Pre-defined methods in `AppDatabase` class
- Use Drift's type-safe query builders
- NEVER write raw SQL queries

**Migrations:**
- Increment `schemaVersion` in `AppDatabase`
- Implement migration in `onUpgrade`
- Test migrations with existing data

## Session vs Shift Distinction

**Session:**
- Temporary UI state (in-memory)
- Lost on screen lock or app restart
- Managed by `AuthBloc`

**Shift:**
- Persistent financial record (database)
- Continues until explicit clock-out
- Managed by `ShiftBloc`
- Includes cash tracking and break periods

**Critical Rule:** A user can have a session without a shift, but financial operations require an active shift.

## Feature Structure

Each feature follows this structure:
```
lib/features/<feature_name>/
├── data/
│   ├── datasources/          # Drift database interactions
│   ├── repositories/         # Repository implementations
│   └── models/              # Data transfer objects (if needed)
├── domain/
│   ├── entities/            # Business objects
│   ├── repositories/        # Repository interfaces
│   └── usecases/           # Business logic operations
└── presentation/
    ├── bloc/               # State management
    ├── pages/              # Full screen widgets
    └── widgets/            # Reusable components
```

## Current Implementation Status

**Implemented:**
- ✅ Authentication with PIN (4-digit, hashed with SHA-256)
- ✅ Login lockout after 3 failed attempts
- ✅ Clock-In/Clock-Out with cash register tracking
- ✅ Break management (start/end breaks within shifts)
- ✅ Screen lock (session management)
- ✅ Audit event logging
- ✅ Employee management foundation (CRUD in progress)

**In Progress:**
- Employee CRUD operations (partial implementation)
- Employee list display
- Employee BLoC integration

**Pending:**
- Sales module
- Inventory/Stock module
- Reporting and advanced auditing
- Backend synchronization
- Hardware integration (printer, cash drawer)

## Type Safety & Error Handling

**Strict Typing:**
- NEVER use `dynamic` unless absolutely necessary
- Drift provides compile-time type safety - use it
- Value objects enforce domain constraints

**Error Handling:**
- Use `Either<Failure, T>` pattern from `dartz`
- Define specific `Failure` types in `lib/core/error/failures.dart`
- Handle errors at BLoC level, emit error states
- NEVER silence errors

**Failure Types:**
- `AuthFailure`: Authentication/authorization errors
- `DatabaseFailure`: Database operation errors
- `ValidationFailure`: Business rule violations
- `NotFoundFailure`: Entity not found
- `DuplicateFailure`: Unique constraint violations
- `UnauthorizedFailure`: Permission errors

## Security Notes

- All PINs stored as SHA-256 hashes
- No PIN recovery mechanism (intentional design for security)
- Automatic lockout after failed attempts
- All critical events logged to `AuditEvents` table
- Soft delete for employees maintains historical integrity

## Logging

Use the `logger` package (already configured):
```dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

NEVER use `print()` statements in production code.

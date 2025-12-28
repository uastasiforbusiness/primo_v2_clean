---
name: architecture-enforcement
description: Enforces Clean Architecture and Hexagonal Architecture principles in PRIMO_V2. Use when reviewing code, detecting violations, or proposing new features to ensure architectural integrity.
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Architecture Enforcement Specialist

You are the guardian of PRIMO_V2's architecture integrity.

## Architecture Layers

presentation/ (UI)
↓ events
bloc/ (State Management)
↓ use case calls
domain/ (Business Logic)
↓ repository interfaces
data/ (Infrastructure)
↓ datasources
database/ (Drift)

text

## Prohibited Dependencies

❌ **Domain → Data** (Domain NEVER imports infrastructure)
❌ **Domain → Presentation** (Domain is independent)
❌ **Business logic in Widgets** (Belongs in UseCases)
❌ **BLoC → DataSource** (Must go through Repository)

## Violation Detection

### Scan for violations:

Check if domain imports data
grep -r "import.*features.data" lib/features//domain/

Check if widgets have business logic
grep -r "if.role.==" lib/features/*/presentation/pages/

text

### Common Violations:

**1. Business Logic in Widget**
// ❌ WRONG
if (employee.role == Role.ADMIN && amount > 1000) {
// Permission check in UI
}

// ✓ RIGHT - UseCase handles this
final canProcess = await checkPermissions.call(employee, amount);

text

**2. BLoC Calls DataSource**
// ❌ WRONG
class AuthBloc {
final AppDatabase database;
}

// ✓ RIGHT
class AuthBloc {
final AuthRepository repository;
}

text

**3. UseCase Returns Entity (Not Model)**
// ❌ WRONG
class GetEmployeeUseCase {
Future<Employee> call(String id) {
return repository.getEmployee(id); // Returns domain entity
}
}

// ✓ RIGHT - Repository returns entity

text

## New Feature Checklist

When creating new feature:

1. **Domain Layer**
   - [ ] Entity defined (`domain/entities/`)
   - [ ] Repository interface (`domain/repositories/`)
   - [ ] UseCases (`domain/usecases/`)
   - [ ] Value Objects if needed (`core/shared_kernel/`)

2. **Data Layer**
   - [ ] Drift table if needed (`features/database/data/`)
   - [ ] Repository implementation (`data/repositories/`)
   - [ ] DataSource if external API (`data/datasources/`)

3. **Presentation Layer**
   - [ ] BLoC (`presentation/bloc/`)
   - [ ] Events (`presentation/bloc/*_event.dart`)
   - [ ] States (`presentation/bloc/*_state.dart`)
   - [ ] Pages (`presentation/pages/`)
   - [ ] Widgets (`presentation/widgets/`)

4. **DI Container**
   - [ ] Register in `lib/di/injection_container.dart`

## Automated Checks (via Subagent)

For full codebase audit:

Use Task tool (subagent_type: explore) to:

Scan all imports across layers

Detect dependency violations

Find business logic in widgets

Report coupling issues

text

## Enforcement Script

Create `.claude/skills/architecture-enforcement/check_violations.sh`:

#!/bin/bash
echo "Scanning for architecture violations..."

Domain importing data
echo "Checking domain → data imports..."
grep -r "import.*features.data" lib/features//domain/ && echo "❌ VIOLATION" || echo "✓ OK"

Business logic in widgets
echo "Checking business logic in widgets..."
grep -r "if.role.==" lib/features/*/presentation/pages/ && echo "❌ VIOLATION" || echo "✓ OK"

echo "Scan complete."

text
undefined

---
name: bloc-architecture
description: Expert guidance for BLoC pattern implementation in PRIMO_V2. Use when creating or modifying BLoCs, Events, States, or analyzing state management flow. Also use for debugging BLoC-related issues.
allowed-tools: Read, Grep, Glob
---

# BLoC Architecture Expert for PRIMO_V2

You are a BLoC pattern specialist for the PRIMO_V2 POS system.

## BLoC Pattern Rules

### Event Naming
**Past tense verbs:**
- ✓ `LoginRequested`, `ClockInRequested`, `CreateEmployeeRequested`
- ✗ `Login`, `ClockIn`, `CreateEmployee`

### State Naming
**Present tense nouns:**
- ✓ `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`
- ✗ `Authenticating`, `LoginSuccess`

### State Structure
@immutable
class EmployeeLoaded extends EmployeeState {
final List<Employee> employees;

const EmployeeLoaded(this.employees);

@override
List<Object?> get props => [employees];
}

text

### Event Handler Template
Future<void> _onEvent(Event event, Emitter<State> emit) async {
emit(Loading());

final result = await useCase(event.param);

result.fold(
(failure) => emit(Error(failure.message)),
(data) => emit(Success(data)),
);
}

text

## Architecture Layers

**Flow:**
Widget → Event → BLoC Handler → UseCase → Repository → DataSource (Drift)

text

**Rules:**
- BLoCs NEVER import DataSource directly
- BLoCs NEVER have business logic (delegates to UseCases)
- States are ALWAYS immutable
- Events ALWAYS use Equatable

## Common Violations

### ❌ Business Logic in BLoC
// WRONG
if (amount > 1000 && user.role != 'ADMIN') {
emit(Error('Unauthorized'));
}

// RIGHT - UseCase handles this
final result = await validateTransaction(amount, user);

text

### ❌ Direct DataSource Access
// WRONG
class AuthBloc {
final AppDatabase database; // Never!
}

// RIGHT
class AuthBloc {
final AuthRepository repository; // Through abstraction
}

text

## Testing Pattern

blocTest<EmployeeBloc, EmployeeState>(
'emits [Loading, Loaded] on success',
build: () {
when(() => mockUseCase(...))
.thenAnswer((_) async => Right(employee));
return EmployeeBloc(useCase: mockUseCase);
},
act: (bloc) => bloc.add(CreateEmployeeRequested(...)),
expect: () => [
EmployeeLoading(),
EmployeeLoaded(employee),
],
);

text

## Key Files

- BLoCs: `lib/features/*/presentation/bloc/*_bloc.dart`
- Events: `lib/features/*/presentation/bloc/*_event.dart`
- States: `lib/features/*/presentation/bloc/*_state.dart`
- UseCases: `lib/features/*/domain/usecases/*.dart`

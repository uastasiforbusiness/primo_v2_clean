# AGENTS.md - PRIMO_V2 Development Guide

## Build, Lint, and Test Commands

```bash
# Install dependencies
flutter pub get

# Generate code (Drift/Freezed/Json) - RUN THIS AFTER DATABASE SCHEMA CHANGES
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application
flutter run

# Run all tests
flutter test

# Run single test file
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart

# Run single test case
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart --name="initial state should be AuthInitial"

# Run static analysis
flutter analyze

# Format code
dart format .
```

## Code Style Guidelines

### Imports and Directives
- **Order**: `dart:` → `package:` → relative imports
- **Section comments**: Group imports by feature (e.g., `// Auth Imports`)
- **Enforced**: `directives_ordering` linter rule enabled
- **Domain Layer**: NEVER import `data`, `presentation`, `flutter_bloc`, or `drift`. Pure Dart only.

### Formatting
- **Quotes**: Single quotes only (`prefer_single_quotes`)
- **Const**: Prefer `const` constructors and literals
- **Final**: Prefer `final` for fields and locals (`prefer_final_fields`, `prefer_final_locals`)
- **Trailing commas**: Required (`require_trailing_commas`)
- **Lambdas**: Avoid unnecessary lambdas (`unnecessary_lambdas`)
- **This**: Avoid unnecessary `this` (`unnecessary_this`)

### Types and Typing
- **Forbidden**: `dynamic` - ALWAYS use specific types
- **Return types**: Always declare (`always_declare_return_types`)
- **Async**: Use `Either<Failure, T>` from `dartz` for error handling
- **Value Objects**: Use `Money`, `Pin`, `Role` from `core/shared_kernel` instead of primitives

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Private**: Prefix with `_`
- **UseCases**: `PascalCase` + `UseCase` suffix (e.g., `LoginWithPinUseCase`)
- **BLoCs**: `PascalCase` + `Bloc` suffix (e.g., `AuthBloc`)
- **Events**: `PascalCase` + suffix (e.g., `LoginWithPinRequested`)
- **States**: `PascalCase` + noun (e.g., `AuthLoading`, `AuthAuthenticated`)

### Error Handling
```dart
// Data Layer: Throw Exceptions
throw DatabaseException('Connection failed');
throw ValidationException('Invalid PIN format');

// Domain Layer: Return Either<Failure, T>
Future<Either<Failure, EmployeeEntity>> call(String pin) async {
  try {
    return await repository.loginWithPin(pin);
  } catch (e) {
    return Left(DatabaseFailure(message: e.toString()));
  }
}

// NEVER catch silently - always convert to Failure
```

### BLoC Patterns
- One BLoC = One Responsibility
- Use `Logger` from `logger` package, never `print()`
- Event handlers must be `Future<void>` methods
- State changes via `emit()`
- Log with emojis for clarity: `logger.i('✅ Login successful')`

### Database Operations
```dart
// CRITICAL: Financial operations MUST use transactions
await database.transaction(() async {
  await database.insertShift(shift);
  await database.updateCashRegister(register);
  // If any fails, automatic rollback
});
```

### Clean Architecture Workflow
1. **Domain**: Entity → Repository Interface → UseCase
2. **Data**: Drift Table → Model → Repository Impl
3. **Presentation**: Event → State → BLoC → UI

### Dependency Injection (GetIt)
```dart
// In lib/di/injection_container.dart

// BLoCs: registerFactory (new instance each time)
sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

// UseCases/Repositories: registerLazySingleton (single instance)
sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...));

// External services: registerLazySingleton
sl.registerLazySingleton(() => const FlutterSecureStorage());
```

### Testing
```dart
// Use bloc_test for BLoC testing
blocTest<AuthBloc, AuthState>(
  'emits [Loading, Authenticated] when login succeeds',
  build: () => authBloc,
  act: (bloc) => bloc.add(LoginWithPinRequested('1234')),
  expect: () => [AuthLoading(), AuthAuthenticated(employee)],
);

// Use mockito for mocking dependencies
@GenerateMocks([LoginWithPinUseCase])
```

### Architecture Violations to Check
```bash
# If these return anything, architecture is BROKEN:
grep -r "import.*features.*data" lib/features/*/domain/
grep -r "import.*features.*presentation" lib/features/*/domain/
```

## Critical Rules (Non-Negotiable)
1. Domain layer purity - no Flutter/Drift dependencies
2. ACID transactions for all financial operations
3. Strong typing only - NO `dynamic`
4. Either<Failure, T> for all error handling
5. One BLoC per feature, one responsibility per BLoC

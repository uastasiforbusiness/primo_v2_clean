# Drift ORM Reference

## Transacciones (MANDATORIO)

await database.transaction(() async {
await database.insertShift(...);
await database.insertAuditEvent(...);
// Ambas succeed o ambas fallan
});

text

## Type-Safe Queries

// ✓ CORRECTO
final results = await (select(employees)
..where((e) => e.isActive.equals(true))
).get();

// ✗ INCORRECTO
final results = await customSelect('SELECT * FROM employees').get();

text

## Regeneración

flutter pub run build_runner build --delete-conflicting-outputs

text
undefined
Archivo 9: .claude-research-docs/bloc-patterns.md
bash
touch .claude-research-docs/bloc-patterns.md
Contenido:

text
# BLoC Patterns

## Naming

✅ Events: `LoginRequested`, `ClockInRequested`
✅ States: `AuthLoading`, `AuthAuthenticated`, `AuthError`

## Template

Future<void> _onEvent(Event event, Emitter<State> emit) async {
emit(Loading());

final result = await useCase(event.param);

result.fold(
(failure) => emit(Error(failure.message)),
(data) => emit(Success(data)),
);
}

text
undefined

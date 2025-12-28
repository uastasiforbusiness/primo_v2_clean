---
name: drift-database
description: Expert guidance for Drift ORM operations. Use when implementing database schemas, migrations, queries, or transactions. Also use when debugging Drift-related issues or reviewing database code for PRIMO_V2.
allowed-tools: Read, Grep, Glob, Bash
---

# Drift Database Expert for PRIMO_V2

You are a Drift ORM specialist for the PRIMO_V2 POS system.

## Critical Rules

**BEFORE implementing ANY database code:**

1. Check current schema at `lib/features/database/data/app_database.dart`
2. Verify schemaVersion before migrations
3. ALL financial operations MUST use `database.transaction()`
4. NEVER use raw SQL - always type-safe queries

## Transactional Operations (MANDATORY)

await database.transaction(() async {
await database.insertShift(...);
await database.insertAuditEvent(...);
// Both succeed or both fail (atomic)
});

text

## Type-Safe Queries

// ✓ CORRECT
final results = await (select(employees)
..where((e) => e.isActive.equals(true))
).get();

// ✗ WRONG - Never do this
final results = await customSelect('SELECT * FROM ...').get();

text

## Schema Migrations

When creating migrations:

1. Increment `schemaVersion` in `AppDatabase`
2. Add migration logic in `onUpgrade`
3. Test with real data (not empty DB)
4. Document breaking changes

@override
int get schemaVersion => 6; // Increment this

@override
MigrationStrategy get migration => MigrationStrategy(
onUpgrade: (m, from, to) async {
if (from < 6) {
// Migration code here
}
},
);

text

## Audit Trail Requirements

Every financial operation logs to AuditEvents:

await database.insertAuditEvent(
AuditEventCompanion.insert(
eventType: 'CLOCK_IN',
employeeId: employeeId,
timestamp: DateTime.now(),
details: Value('Initial cash: ${initialCash.value}'),
),
);

text

## Common Patterns

### Compound Queries
Use `where()` chains for complex filtering

### Relationships
Use joins, not manual lookups

### Error Handling
Wrap in try-catch, return `Either<Failure, T>`

## Files to Reference

- Schema: `lib/features/database/data/app_database.dart`
- Repositories: `lib/features/*/data/repositories/*_repository_impl.dart`
- Models: `lib/features/database/data/models/*.dart`

## When to Spawn Subagent

For complex schema analysis spanning many tables:

Use Task tool with subagent_type: 'explore'
Let it scan all table definitions and return summary

text
undefined

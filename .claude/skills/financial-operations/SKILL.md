---
name: financial-operations
description: Specialist for money handling, audit trails, and transactional safety in PRIMO_V2. Use when working with shifts, cash registers, payments, or any money-related operations. Critical for maintaining financial integrity.
allowed-tools: Read, Grep, Glob, Bash
---

# Financial Operations Specialist

You ensure every money operation is safe, audited, and transactional.

## CRITICAL: All Money Operations Are Transactional

await database.transaction(() async {
// 1. Insert shift
final shiftId = await database.insertShift(...);

// 2. Log audit event
await database.insertAuditEvent(
AuditEventCompanion.insert(
eventType: 'CLOCK_IN',
employeeId: employeeId,
relatedId: Value(shiftId),
timestamp: DateTime.now(),
details: Value('Initial cash: ${initialCash.value}'),
),
);

// Both succeed OR both fail
});

text

## Validation Before Money Movement

// 1. Employee exists and active?
final employee = await repository.getEmployeeById(id);
if (employee == null || !employee.isActive) {
return Left(ValidationFailure('Invalid employee'));
}

// 2. No active shift?
final hasActiveShift = await repository.hasActiveShift(id);
if (hasActiveShift) {
return Left(ValidationFailure('Already clocked in'));
}

// 3. Money amount valid?
if (initialCash.isNegative) {
return Left(ValidationFailure('Invalid cash amount'));
}

// Then proceed with transaction

text

## Audit Events (MANDATORY)

Every critical operation logs:

| Operation | Event Type | Details Field |
|-----------|------------|---------------|
| Clock In | `CLOCK_IN` | Initial cash amount |
| Clock Out | `CLOCK_OUT` | Final cash, sales summary |
| Cash Adjustment | `CASH_ADJUSTMENT` | Reason, amount, before/after |
| Employee Created | `EMPLOYEE_CREATED` | Role, permissions |
| PIN Changed | `PIN_CHANGED` | Employee ID (NOT the PIN) |

## Money Value Object

final amount = Money.fromDouble(99.99);
final zero = Money.zero();
final sum = amount + Money.fromDouble(10.00);

// Always use Money type, never raw doubles

text

## Error Scenarios

| Scenario | Failure Type | Response |
|----------|--------------|----------|
| Employee not found | `NotFoundFailure` | Require valid employee |
| Already clocked in | `ValidationFailure` | Clock out first |
| Negative cash | `ValidationFailure` | Validate input |
| DB transaction fails | `DatabaseFailure` | Log & retry |

## Testing Financial Operations

test('clock in creates shift AND audit event atomically', () async {
// Act
final result = await repository.clockIn(...);

// Assert both created
final shift = await database.getShift(shiftId);
final audit = await database.getLatestAuditEvent();

expect(shift, isNotNull);
expect(audit.eventType, 'CLOCK_IN');
});

test('failed transaction rolls back both operations', () async {
// Arrange: Simulate DB failure
when(() => database.insertAuditEvent(...))
.thenThrow(Exception('DB error'));

// Act
final result = await repository.clockIn(...);

// Assert: Shift NOT created (rolled back)
final shifts = await database.getAllShifts();
expect(shifts, isEmpty);
});

text

## When to Use Subagent

For auditing entire codebase:

Spawn 'explore' subagent to:

Find all Money operations

Verify ALL use database.transaction()

Check ALL critical ops have AuditEvents

Report violations

text
undefined


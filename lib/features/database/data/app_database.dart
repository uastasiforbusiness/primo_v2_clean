import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ==================== TABLES ====================

class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get emergencyPhone => text().named('emergency_phone')();
  TextColumn get role => text()();
  TextColumn get pinHash => text().named('pin_hash')();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CashRegisters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Shifts extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text().named('employee_id').references(Employees, #id)();
  TextColumn get cashRegisterId => text().named('cash_register_id').references(CashRegisters, #id)();
  RealColumn get initialCash => real().named('initial_cash')();
  RealColumn get finalCash => real().named('final_cash').nullable()();
  DateTimeColumn get startedAt => dateTime().named('started_at').withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().named('ended_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Breaks extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text().named('shift_id').references(Shifts, #id)();
  DateTimeColumn get startedAt => dateTime().named('started_at').withDefault(currentDateAndTime)();
  DateTimeColumn get endedAt => dateTime().named('ended_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuditEvents extends Table {
  TextColumn get id => text()();
  TextColumn get eventType => text().named('event_type')();
  TextColumn get employeeId => text().named('employee_id').nullable().references(Employees, #id)();
  TextColumn get metadata => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime().named('created_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== DATABASE ====================

@DriftDatabase(tables: [
  Employees,
  CashRegisters,
  Shifts,
  Breaks,
  AuditEvents,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations here
        },
      );

  Future<void> _seedInitialData() async {
    // Default cash register
    await into(cashRegisters).insert(
      CashRegistersCompanion.insert(
        id: 'default-register',
        name: 'Caja Principal',
      ),
    );

    // Default admin user (PIN: 1234, hashed)
    await into(employees).insert(
      EmployeesCompanion.insert(
        id: 'admin-001',
        name: 'Administrador',
        lastName: 'Sistema',
        emergencyPhone: '000000000',
        role: 'ADMIN',
        pinHash: 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', // SHA-256 of "123"
        email: const Value('admin@primo.com'),
      ),
    );
  }

  // ==================== EMPLOYEE QUERIES ====================

  Future<List<Employee>> getAllEmployees() => select(employees).get();

  Future<List<Employee>> getActiveEmployees() =>
      (select(employees)..where((e) => e.isActive.equals(true))).get();

  Future<Employee?> getEmployeeById(String id) =>
      (select(employees)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<Employee?> getEmployeeByPinHash(String pinHash) =>
      (select(employees)..where((e) => e.pinHash.equals(pinHash))).getSingleOrNull();

  Future<bool> isPinUnique(String pinHash, {String? excludeEmployeeId}) async {
    final query = select(employees)..where((e) => e.pinHash.equals(pinHash));
    
    if (excludeEmployeeId != null) {
      query.where((e) => e.id.equals(excludeEmployeeId).not());
    }
    
    final result = await query.getSingleOrNull();
    return result == null;
  }

  Future<int> insertEmployee(EmployeesCompanion employee) =>
      into(employees).insert(employee);

  Future<bool> updateEmployee(EmployeesCompanion employee) =>
      update(employees).replace(employee);

  Future<int> softDeleteEmployee(String id) =>
      (update(employees)..where((e) => e.id.equals(id)))
          .write(const EmployeesCompanion(isActive: Value(false)));

  // ==================== SHIFT QUERIES ====================

  Future<Shift?> getActiveShiftByEmployeeId(String employeeId) =>
      (select(shifts)
            ..where((s) => s.employeeId.equals(employeeId))
            ..where((s) => s.endedAt.isNull()))
          .getSingleOrNull();

  Future<int> insertShift(ShiftsCompanion shift) =>
      into(shifts).insert(shift);

  Future<int> closeShift(String shiftId, double finalCash) =>
      (update(shifts)..where((s) => s.id.equals(shiftId))).write(
        ShiftsCompanion(
          finalCash: Value(finalCash),
          endedAt: Value(DateTime.now()),
        ),
      );

  // ==================== BREAK QUERIES ====================

  Future<Break?> getActiveBreakByShiftId(String shiftId) =>
      (select(breaks)
            ..where((b) => b.shiftId.equals(shiftId))
            ..where((b) => b.endedAt.isNull()))
          .getSingleOrNull();

  Future<int> insertBreak(BreaksCompanion breakEntry) =>
      into(breaks).insert(breakEntry);

  Future<int> endBreak(String breakId) =>
      (update(breaks)..where((b) => b.id.equals(breakId)))
          .write(BreaksCompanion(endedAt: Value(DateTime.now())));

  // ==================== AUDIT QUERIES ====================

  Future<int> insertAuditEvent(AuditEventsCompanion event) =>
      into(auditEvents).insert(event);

  Future<List<AuditEvent>> getAuditEvents({int limit = 100}) =>
      (select(auditEvents)
            ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
            ..limit(limit))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'primo_v2.db'));
    return NativeDatabase(file);
  });
}

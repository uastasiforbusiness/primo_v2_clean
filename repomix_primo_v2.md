This file is a merged representation of a subset of the codebase, containing specifically included files and files not matching ignore patterns, combined into a single document by Repomix.

<file_summary>
This section contains a summary of this file.

<purpose>
This file contains a packed representation of a subset of the repository's contents that is considered the most important context.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.
</purpose>

<file_format>
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  - File path as an attribute
  - Full contents of the file
</file_format>

<usage_guidelines>
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
</usage_guidelines>

<notes>
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: lib/**, pubspec.yaml, analysis_options.yaml
- Files matching these patterns are excluded: **/build/**, **/.dart_tool/**, **/generated/**
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)
</notes>

</file_summary>

<directory_structure>
analysis_options.yaml
lib/core/error/exceptions.dart
lib/core/error/failures.dart
lib/core/shared_kernel/money.dart
lib/core/shared_kernel/pin.dart
lib/core/shared_kernel/role.dart
lib/di/injection_container.dart
lib/features/auth/data/datasources/auth_local_datasource.dart
lib/features/auth/data/models/employee_model.dart
lib/features/auth/data/models/shift_model.dart
lib/features/auth/data/repositories/auth_repository_impl.dart
lib/features/auth/domain/entities/employee_entity.dart
lib/features/auth/domain/entities/shift_entity.dart
lib/features/auth/domain/repositories/auth_repository.dart
lib/features/auth/domain/usecases/clock_in_usecase.dart
lib/features/auth/domain/usecases/clock_out_usecase.dart
lib/features/auth/domain/usecases/login_with_pin_usecase.dart
lib/features/auth/presentation/bloc/auth_bloc.dart
lib/features/auth/presentation/bloc/auth_event.dart
lib/features/auth/presentation/bloc/auth_state.dart
lib/features/auth/presentation/pages/clock_in_page.dart
lib/features/auth/presentation/pages/login_page.dart
lib/features/auth/presentation/widgets/numpad_widget.dart
lib/features/database/data/app_database.dart
lib/features/database/data/app_database.g.dart
lib/features/employees/presentation/pages/dashboard_page.dart
lib/main.dart
pubspec.yaml
</directory_structure>

<files>
This section contains the contents of the repository's files.

<file path="analysis_options.yaml">
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_single_quotes
    - always_declare_return_types
    - avoid_dynamic_calls
</file>

<file path="lib/core/error/exceptions.dart">
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

class DuplicateException implements Exception {
  final String message;
  DuplicateException(this.message);

  @override
  String toString() => 'DuplicateException: $message';
}
</file>

<file path="lib/core/error/failures.dart">
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});
}

class DuplicateFailure extends Failure {
  const DuplicateFailure({required super.message, super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message, super.code});
}
</file>

<file path="lib/core/shared_kernel/money.dart">
import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final double amount;

  const Money._(this.amount);

  factory Money.fromDouble(double value) {
    if (value < 0) {
      throw ArgumentError('Money amount cannot be negative');
    }
    return Money._(value);
  }

  factory Money.zero() => const Money._(0.0);

  Money operator +(Money other) => Money._(amount + other.amount);
  Money operator -(Money other) {
    final result = amount - other.amount;
    if (result < 0) {
      throw ArgumentError('Money amount cannot be negative after subtraction');
    }
    return Money._(result);
  }

  Money operator *(double multiplier) => Money._(amount * multiplier);

  bool operator >(Money other) => amount > other.amount;
  bool operator <(Money other) => amount < other.amount;
  bool operator >=(Money other) => amount >= other.amount;
  bool operator <=(Money other) => amount <= other.amount;

  bool get isZero => amount == 0.0;
  bool get isPositive => amount > 0.0;

  String toFormattedString({String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  @override
  List<Object?> get props => [amount];
}
</file>

<file path="lib/core/shared_kernel/pin.dart">
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';

class Pin extends Equatable {
  final String value;

  const Pin._(this.value);

  factory Pin.fromPlainText(String plainText) {
    if (plainText.length != 4) {
      throw ArgumentError('PIN must be exactly 4 digits');
    }
    
    if (!RegExp(r'^\d{4}$').hasMatch(plainText)) {
      throw ArgumentError('PIN must contain only digits');
    }
    
    return Pin._(plainText);
  }

  factory Pin.fromHash(String hash) {
    return Pin._(hash);
  }

  String toHash() {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool verify(String plainText) {
    final bytes = utf8.encode(plainText);
    final digest = sha256.convert(bytes);
    return digest.toString() == value;
  }

  @override
  List<Object?> get props => [value];
}
</file>

<file path="lib/core/shared_kernel/role.dart">
import 'package:equatable/equatable.dart';

enum RoleType {
  admin,
  supervisor,
  staff,
  kitchen,
}

class Role extends Equatable {
  final RoleType type;

  const Role._(this.type);

  factory Role.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return const Role._(RoleType.admin);
      case 'SUPERVISOR':
        return const Role._(RoleType.supervisor);
      case 'STAFF':
        return const Role._(RoleType.staff);
      case 'KITCHEN':
        return const Role._(RoleType.kitchen);
      default:
        throw ArgumentError('Invalid role: $value');
    }
  }

  static const Role admin = Role._(RoleType.admin);
  static const Role supervisor = Role._(RoleType.supervisor);
  static const Role staff = Role._(RoleType.staff);
  static const Role kitchen = Role._(RoleType.kitchen);

  String toValue() {
    switch (type) {
      case RoleType.admin:
        return 'ADMIN';
      case RoleType.supervisor:
        return 'SUPERVISOR';
      case RoleType.staff:
        return 'STAFF';
      case RoleType.kitchen:
        return 'KITCHEN';
    }
  }

  bool get canManageEmployees => type == RoleType.admin || type == RoleType.supervisor;
  bool get canAccessReports => type == RoleType.admin || type == RoleType.supervisor;
  bool get canOperatePOS => type == RoleType.admin || type == RoleType.staff;
  bool get canAccessKitchen => type == RoleType.admin || type == RoleType.kitchen;

  @override
  List<Object?> get props => [type];
}
</file>

<file path="lib/di/injection_container.dart">
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../features/database/data/app_database.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/domain/usecases/clock_in_usecase.dart';
import '../features/auth/domain/usecases/clock_out_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== Core ====================
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  // ==================== Database ====================
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ==================== Auth Feature ====================
  
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      database: sl(),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginWithPinUseCase: sl(),
      clockInUseCase: sl(),
      clockOutUseCase: sl(),
      authRepository: sl(),
    ),
  );
}
</file>

<file path="lib/features/auth/data/models/employee_model.dart">
import '../../../../core/shared_kernel/role.dart';
import '../../../database/data/app_database.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.lastName,
    super.email,
    super.phone,
    required super.emergencyPhone,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EmployeeModel.fromDrift(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      lastName: employee.lastName,
      email: employee.email,
      phone: employee.phone,
      emergencyPhone: employee.emergencyPhone,
      role: Role.fromString(employee.role),
      isActive: employee.isActive,
      createdAt: employee.createdAt,
      updatedAt: employee.updatedAt,
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
      emergencyPhone: emergencyPhone,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
</file>

<file path="lib/features/auth/data/models/shift_model.dart">
import '../../../../core/shared_kernel/money.dart';
import '../../../database/data/app_database.dart';
import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.employeeId,
    required super.cashRegisterId,
    required super.initialCash,
    super.finalCash,
    required super.startedAt,
    super.endedAt,
  });

  factory ShiftModel.fromDrift(Shift shift) {
    return ShiftModel(
      id: shift.id,
      employeeId: shift.employeeId,
      cashRegisterId: shift.cashRegisterId,
      initialCash: Money.fromDouble(shift.initialCash),
      finalCash: shift.finalCash != null ? Money.fromDouble(shift.finalCash!) : null,
      startedAt: shift.startedAt,
      endedAt: shift.endedAt,
    );
  }

  ShiftEntity toEntity() {
    return ShiftEntity(
      id: id,
      employeeId: employeeId,
      cashRegisterId: cashRegisterId,
      initialCash: initialCash,
      finalCash: finalCash,
      startedAt: startedAt,
      endedAt: endedAt,
    );
  }
}
</file>

<file path="lib/features/auth/data/repositories/auth_repository_impl.dart">
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/employee_model.dart';
import '../models/shift_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, EmployeeEntity>> loginWithPin(String pin) async {
    try {
      final employee = await localDataSource.loginWithPin(pin);
      final model = EmployeeModel.fromDrift(employee);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShiftEntity>> clockIn({
    required String employeeId,
    required Money initialCash,
  }) async {
    try {
      final shift = await localDataSource.clockIn(
        employeeId: employeeId,
        initialCash: initialCash.amount,
      );
      final model = ShiftModel.fromDrift(shift);
      return Right(model.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clockOut({
    required String shiftId,
    required Money finalCash,
  }) async {
    try {
      await localDataSource.clockOut(
        shiftId: shiftId,
        finalCash: finalCash.amount,
      );
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShiftEntity?>> getActiveShift(String employeeId) async {
    try {
      final shift = await localDataSource.getActiveShift(employeeId);
      if (shift == null) {
        return const Right(null);
      }
      final model = ShiftModel.fromDrift(shift);
      return Right(model.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> startBreak(String shiftId) async {
    try {
      await localDataSource.startBreak(shiftId);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> endBreak(String shiftId) async {
    try {
      await localDataSource.endBreak(shiftId);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasActiveBreak(String shiftId) async {
    try {
      final hasBreak = await localDataSource.hasActiveBreak(shiftId);
      return Right(hasBreak);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
</file>

<file path="lib/features/auth/domain/entities/employee_entity.dart">
import 'package:equatable/equatable.dart';
import '../../../../core/shared_kernel/role.dart';

class EmployeeEntity extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final String? email;
  final String? phone;
  final String emergencyPhone;
  final Role role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.lastName,
    this.email,
    this.phone,
    required this.emergencyPhone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$name $lastName';

  @override
  List<Object?> get props => [
        id,
        name,
        lastName,
        email,
        phone,
        emergencyPhone,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}
</file>

<file path="lib/features/auth/domain/entities/shift_entity.dart">
import 'package:equatable/equatable.dart';
import '../../../../core/shared_kernel/money.dart';

class ShiftEntity extends Equatable {
  final String id;
  final String employeeId;
  final String cashRegisterId;
  final Money initialCash;
  final Money? finalCash;
  final DateTime startedAt;
  final DateTime? endedAt;

  const ShiftEntity({
    required this.id,
    required this.employeeId,
    required this.cashRegisterId,
    required this.initialCash,
    this.finalCash,
    required this.startedAt,
    this.endedAt,
  });

  bool get isActive => endedAt == null;

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        cashRegisterId,
        initialCash,
        finalCash,
        startedAt,
        endedAt,
      ];
}
</file>

<file path="lib/features/auth/domain/repositories/auth_repository.dart">
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../entities/employee_entity.dart';
import '../entities/shift_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, EmployeeEntity>> loginWithPin(String pin);
  Future<Either<Failure, ShiftEntity>> clockIn({
    required String employeeId,
    required Money initialCash,
  });
  Future<Either<Failure, void>> clockOut({
    required String shiftId,
    required Money finalCash,
  });
  Future<Either<Failure, ShiftEntity?>> getActiveShift(String employeeId);
  Future<Either<Failure, void>> startBreak(String shiftId);
  Future<Either<Failure, void>> endBreak(String shiftId);
  Future<Either<Failure, bool>> hasActiveBreak(String shiftId);
}
</file>

<file path="lib/features/auth/domain/usecases/clock_in_usecase.dart">
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../entities/shift_entity.dart';
import '../repositories/auth_repository.dart';

class ClockInUseCase {
  final AuthRepository repository;

  ClockInUseCase(this.repository);

  Future<Either<Failure, ShiftEntity>> call({
    required String employeeId,
    required double initialCashAmount,
  }) async {
    // Validate initial cash
    if (initialCashAmount < 0) {
      return const Left(
        ValidationFailure(message: 'Initial cash cannot be negative'),
      );
    }

    // Check if employee already has an active shift
    final activeShiftResult = await repository.getActiveShift(employeeId);
    
    return activeShiftResult.fold(
      (failure) => Left(failure),
      (activeShift) {
        if (activeShift != null) {
          return const Left(
            ValidationFailure(message: 'Employee already has an active shift'),
          );
        }

        final initialCash = Money.fromDouble(initialCashAmount);
        return repository.clockIn(
          employeeId: employeeId,
          initialCash: initialCash,
        );
      },
    );
  }
}
</file>

<file path="lib/features/auth/domain/usecases/clock_out_usecase.dart">
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../repositories/auth_repository.dart';

class ClockOutUseCase {
  final AuthRepository repository;

  ClockOutUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String shiftId,
    required double finalCashAmount,
  }) async {
    // Validate final cash
    if (finalCashAmount < 0) {
      return const Left(
        ValidationFailure(message: 'Final cash cannot be negative'),
      );
    }

    // Check if there's an active break
    final hasActiveBreakResult = await repository.hasActiveBreak(shiftId);
    
    return hasActiveBreakResult.fold(
      (failure) => Left(failure),
      (hasBreak) {
        if (hasBreak) {
          return const Left(
            ValidationFailure(message: 'Cannot clock out with an active break'),
          );
        }

        final finalCash = Money.fromDouble(finalCashAmount);
        return repository.clockOut(
          shiftId: shiftId,
          finalCash: finalCash,
        );
      },
    );
  }
}
</file>

<file path="lib/features/auth/domain/usecases/login_with_pin_usecase.dart">
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/employee_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithPinUseCase {
  final AuthRepository repository;

  LoginWithPinUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call(String pin) async {
    // Validate PIN format
    if (pin.length != 4) {
      return const Left(
        ValidationFailure(message: 'PIN must be 4 digits'),
      );
    }

    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      return const Left(
        ValidationFailure(message: 'PIN must contain only numbers'),
      );
    }

    return await repository.loginWithPin(pin);
  }
}
</file>

<file path="lib/features/auth/presentation/bloc/auth_bloc.dart">
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/usecases/login_with_pin_usecase.dart';
import '../../domain/usecases/clock_in_usecase.dart';
import '../../domain/usecases/clock_out_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPinUseCase loginWithPinUseCase;
  final ClockInUseCase clockInUseCase;
  final ClockOutUseCase clockOutUseCase;
  final AuthRepository authRepository;

  EmployeeEntity? _currentEmployee;
  ShiftEntity? _currentShift;

  AuthBloc({
    required this.loginWithPinUseCase,
    required this.clockInUseCase,
    required this.clockOutUseCase,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    on<LoginWithPinRequested>(_onLoginWithPinRequested);
    on<ClockInRequested>(_onClockInRequested);
    on<ClockOutRequested>(_onClockOutRequested);
    on<StartBreakRequested>(_onStartBreakRequested);
    on<EndBreakRequested>(_onEndBreakRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginWithPinRequested(
    LoginWithPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithPinUseCase(event.pin);

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (employee) async {
        _currentEmployee = employee;

        // Check if employee has an active shift
        final shiftResult = await authRepository.getActiveShift(employee.id);
        
        await shiftResult.fold(
          (failure) async => emit(AuthError(failure.message)),
          (activeShift) async {
            _currentShift = activeShift;
            emit(AuthLoginSuccess(
              employee: employee,
              activeShift: activeShift,
            ));
          },
        );
      },
    );
  }

  Future<void> _onClockInRequested(
    ClockInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await clockInUseCase(
      employeeId: event.employeeId,
      initialCashAmount: event.initialCash,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (shift) {
        _currentShift = shift;
        if (_currentEmployee != null) {
          emit(AuthAuthenticated(
            employee: _currentEmployee!,
            shift: shift,
          ));
        }
      },
    );
  }

  Future<void> _onClockOutRequested(
    ClockOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await clockOutUseCase(
      shiftId: event.shiftId,
      finalCashAmount: event.finalCash,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        _currentShift = null;
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> _onStartBreakRequested(
    StartBreakRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentEmployee == null || _currentShift == null) {
      emit(const AuthError('No active session'));
      return;
    }

    final result = await authRepository.startBreak(event.shiftId);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthOnBreak(
        employee: _currentEmployee!,
        shift: _currentShift!,
      )),
    );
  }

  Future<void> _onEndBreakRequested(
    EndBreakRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentEmployee == null || _currentShift == null) {
      emit(const AuthError('No active session'));
      return;
    }

    final result = await authRepository.endBreak(event.shiftId);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthAuthenticated(
        employee: _currentEmployee!,
        shift: _currentShift!,
      )),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    _currentEmployee = null;
    // Note: _currentShift is NOT cleared - logout != clock-out
    emit(const AuthUnauthenticated());
  }

  void _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) {
    if (_currentEmployee != null && _currentShift != null) {
      emit(AuthAuthenticated(
        employee: _currentEmployee!,
        shift: _currentShift!,
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
</file>

<file path="lib/features/auth/presentation/bloc/auth_event.dart">
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithPinRequested extends AuthEvent {
  final String pin;

  const LoginWithPinRequested(this.pin);

  @override
  List<Object?> get props => [pin];
}

class ClockInRequested extends AuthEvent {
  final String employeeId;
  final double initialCash;

  const ClockInRequested({
    required this.employeeId,
    required this.initialCash,
  });

  @override
  List<Object?> get props => [employeeId, initialCash];
}

class ClockOutRequested extends AuthEvent {
  final String shiftId;
  final double finalCash;

  const ClockOutRequested({
    required this.shiftId,
    required this.finalCash,
  });

  @override
  List<Object?> get props => [shiftId, finalCash];
}

class StartBreakRequested extends AuthEvent {
  final String shiftId;

  const StartBreakRequested(this.shiftId);

  @override
  List<Object?> get props => [shiftId];
}

class EndBreakRequested extends AuthEvent {
  final String shiftId;

  const EndBreakRequested(this.shiftId);

  @override
  List<Object?> get props => [shiftId];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
</file>

<file path="lib/features/auth/presentation/bloc/auth_state.dart">
import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/shift_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoginSuccess extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity? activeShift;

  const AuthLoginSuccess({
    required this.employee,
    this.activeShift,
  });

  @override
  List<Object?> get props => [employee, activeShift];
}

class AuthAuthenticated extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity shift;

  const AuthAuthenticated({
    required this.employee,
    required this.shift,
  });

  @override
  List<Object?> get props => [employee, shift];
}

class AuthOnBreak extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity shift;

  const AuthOnBreak({
    required this.employee,
    required this.shift,
  });

  @override
  List<Object?> get props => [employee, shift];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
</file>

<file path="lib/features/auth/presentation/pages/clock_in_page.dart">
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../employees/presentation/pages/dashboard_page.dart';

class ClockInPage extends StatefulWidget {
  final EmployeeEntity employee;

  const ClockInPage({
    super.key,
    required this.employee,
  });

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  final _formKey = GlobalKey<FormState>();
  final _initialCashController = TextEditingController();

  @override
  void dispose() {
    _initialCashController.dispose();
    super.dispose();
  }

  void _handleClockIn() {
    if (_formKey.currentState!.validate()) {
      final initialCash = double.tryParse(_initialCashController.text) ?? 0.0;
      
      context.read<AuthBloc>().add(
            ClockInRequested(
              employeeId: widget.employee.id,
              initialCash: initialCash,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Turno'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardPage(
                  employee: state.employee,
                  shift: state.shift,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome message
                      const Icon(
                        Icons.waving_hand,
                        size: 64,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '¡Bienvenido!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.employee.fullName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.deepPurple,
                            ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Initial cash input
                      TextFormField(
                        controller: _initialCashController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Fondo de Caja Inicial',
                          hintText: '0.00',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                          helperText: 'Ingresa el dinero inicial en la caja',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null) {
                            return 'Ingresa un monto válido';
                          }
                          if (amount < 0) {
                            return 'El monto no puede ser negativo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      
                      // Clock-in button
                      ElevatedButton(
                        onPressed: _handleClockIn,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Iniciar Turno',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const LogoutRequested());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
</file>

<file path="lib/features/auth/presentation/pages/login_page.dart">
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/numpad_widget.dart';
import 'clock_in_page.dart';
import '../../../employees/presentation/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _pin = '';
  int _failedAttempts = 0;
  bool _isLocked = false;

  void _onNumberPressed(String number) {
    if (_isLocked) return;
    
    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }
      
      if (_pin.length == 4) {
        context.read<AuthBloc>().add(LoginWithPinRequested(_pin));
      }
    });
  }

  void _onBackspacePressed() {
    if (_isLocked) return;
    
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _onClearPressed() {
    if (_isLocked) return;
    
    setState(() {
      _pin = '';
    });
  }

  void _handleLoginError() {
    setState(() {
      _failedAttempts++;
      _pin = '';
      
      if (_failedAttempts >= 3) {
        _isLocked = true;
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) {
            setState(() {
              _isLocked = false;
              _failedAttempts = 0;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            if (state.activeShift == null) {
              // No active shift - go to clock-in
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ClockInPage(employee: state.employee),
                ),
              );
            } else {
              // Has active shift - go to dashboard
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => DashboardPage(
                    employee: state.employee,
                    shift: state.activeShift!,
                  ),
                ),
              );
            }
          } else if (state is AuthError) {
            _handleLoginError();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Icon(
                    Icons.point_of_sale_rounded,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    'PRIMO V2',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sistema POS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 48),
                  
                  // PIN Display
                  if (_isLocked)
                    Column(
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bloqueado temporalmente',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta nuevamente en 30 segundos',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Ingresa tu PIN',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        
                        // PIN dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index < _pin.length
                                    ? Colors.deepPurple
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Numpad
                        NumpadWidget(
                          onNumberPressed: _onNumberPressed,
                          onBackspacePressed: _onBackspacePressed,
                          onClearPressed: _onClearPressed,
                        ),
                      ],
                    ),
                  
                  if (_failedAttempts > 0 && !_isLocked)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Intentos fallidos: $_failedAttempts/3',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
</file>

<file path="lib/features/auth/presentation/widgets/numpad_widget.dart">
import 'package:flutter/material.dart';

class NumpadWidget extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;

  const NumpadWidget({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                child: const Icon(Icons.clear),
                onPressed: onClearPressed,
              ),
              _buildButton(
                child: const Text(
                  '0',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () => onNumberPressed('0'),
              ),
              _buildButton(
                child: const Icon(Icons.backspace_outlined),
                onPressed: onBackspacePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers
          .map((number) => _buildButton(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => onNumberPressed(number),
              ))
          .toList(),
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: child,
      ),
    );
  }
}
</file>

<file path="lib/features/database/data/app_database.dart">
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
</file>

<file path="lib/features/database/data/app_database.g.dart">
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyPhoneMeta =
      const VerificationMeta('emergencyPhone');
  @override
  late final GeneratedColumn<String> emergencyPhone = GeneratedColumn<String>(
      'emergency_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        lastName,
        email,
        phone,
        emergencyPhone,
        role,
        pinHash,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(Insertable<Employee> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('emergency_phone')) {
      context.handle(
          _emergencyPhoneMeta,
          emergencyPhone.isAcceptableOrUnknown(
              data['emergency_phone']!, _emergencyPhoneMeta));
    } else if (isInserting) {
      context.missing(_emergencyPhoneMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      emergencyPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}emergency_phone'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final String id;
  final String name;
  final String lastName;
  final String? email;
  final String? phone;
  final String emergencyPhone;
  final String role;
  final String pinHash;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Employee(
      {required this.id,
      required this.name,
      required this.lastName,
      this.email,
      this.phone,
      required this.emergencyPhone,
      required this.role,
      required this.pinHash,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['emergency_phone'] = Variable<String>(emergencyPhone);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      lastName: Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      emergencyPhone: Value(emergencyPhone),
      role: Value(role),
      pinHash: Value(pinHash),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      emergencyPhone: serializer.fromJson<String>(json['emergencyPhone']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'emergencyPhone': serializer.toJson<String>(emergencyPhone),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Employee copyWith(
          {String? id,
          String? name,
          String? lastName,
          Value<String?> email = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          String? emergencyPhone,
          String? role,
          String? pinHash,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email.present ? email.value : this.email,
        phone: phone.present ? phone.value : this.phone,
        emergencyPhone: emergencyPhone ?? this.emergencyPhone,
        role: role ?? this.role,
        pinHash: pinHash ?? this.pinHash,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      emergencyPhone: data.emergencyPhone.present
          ? data.emergencyPhone.value
          : this.emergencyPhone,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lastName, email, phone,
      emergencyPhone, role, pinHash, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.emergencyPhone == this.emergencyPhone &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String> emergencyPhone;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.emergencyPhone = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesCompanion.insert({
    required String id,
    required String name,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    required String emergencyPhone,
    required String role,
    required String pinHash,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastName = Value(lastName),
        emergencyPhone = Value(emergencyPhone),
        role = Value(role),
        pinHash = Value(pinHash);
  static Insertable<Employee> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? emergencyPhone,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (emergencyPhone != null) 'emergency_phone': emergencyPhone,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? lastName,
      Value<String?>? email,
      Value<String?>? phone,
      Value<String>? emergencyPhone,
      Value<String>? role,
      Value<String>? pinHash,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (emergencyPhone.present) {
      map['emergency_phone'] = Variable<String>(emergencyPhone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('emergencyPhone: $emergencyPhone, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashRegistersTable extends CashRegisters
    with TableInfo<$CashRegistersTable, CashRegister> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashRegistersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_registers';
  @override
  VerificationContext validateIntegrity(Insertable<CashRegister> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashRegister map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashRegister(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CashRegistersTable createAlias(String alias) {
    return $CashRegistersTable(attachedDatabase, alias);
  }
}

class CashRegister extends DataClass implements Insertable<CashRegister> {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  const CashRegister(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashRegistersCompanion toCompanion(bool nullToAbsent) {
    return CashRegistersCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CashRegister.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashRegister(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashRegister copyWith(
          {String? id, String? name, bool? isActive, DateTime? createdAt}) =>
      CashRegister(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  CashRegister copyWithCompanion(CashRegistersCompanion data) {
    return CashRegister(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashRegister(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashRegister &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CashRegistersCompanion extends UpdateCompanion<CashRegister> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CashRegistersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashRegistersCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<CashRegister> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashRegistersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CashRegistersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashRegistersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _cashRegisterIdMeta =
      const VerificationMeta('cashRegisterId');
  @override
  late final GeneratedColumn<String> cashRegisterId = GeneratedColumn<String>(
      'cash_register_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cash_registers (id)'));
  static const VerificationMeta _initialCashMeta =
      const VerificationMeta('initialCash');
  @override
  late final GeneratedColumn<double> initialCash = GeneratedColumn<double>(
      'initial_cash', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _finalCashMeta =
      const VerificationMeta('finalCash');
  @override
  late final GeneratedColumn<double> finalCash = GeneratedColumn<double>(
      'final_cash', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        employeeId,
        cashRegisterId,
        initialCash,
        finalCash,
        startedAt,
        endedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(Insertable<Shift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('cash_register_id')) {
      context.handle(
          _cashRegisterIdMeta,
          cashRegisterId.isAcceptableOrUnknown(
              data['cash_register_id']!, _cashRegisterIdMeta));
    } else if (isInserting) {
      context.missing(_cashRegisterIdMeta);
    }
    if (data.containsKey('initial_cash')) {
      context.handle(
          _initialCashMeta,
          initialCash.isAcceptableOrUnknown(
              data['initial_cash']!, _initialCashMeta));
    } else if (isInserting) {
      context.missing(_initialCashMeta);
    }
    if (data.containsKey('final_cash')) {
      context.handle(_finalCashMeta,
          finalCash.isAcceptableOrUnknown(data['final_cash']!, _finalCashMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      cashRegisterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cash_register_id'])!,
      initialCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}initial_cash'])!,
      finalCash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_cash']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final String id;
  final String employeeId;
  final String cashRegisterId;
  final double initialCash;
  final double? finalCash;
  final DateTime startedAt;
  final DateTime? endedAt;
  const Shift(
      {required this.id,
      required this.employeeId,
      required this.cashRegisterId,
      required this.initialCash,
      this.finalCash,
      required this.startedAt,
      this.endedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['cash_register_id'] = Variable<String>(cashRegisterId);
    map['initial_cash'] = Variable<double>(initialCash);
    if (!nullToAbsent || finalCash != null) {
      map['final_cash'] = Variable<double>(finalCash);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      cashRegisterId: Value(cashRegisterId),
      initialCash: Value(initialCash),
      finalCash: finalCash == null && nullToAbsent
          ? const Value.absent()
          : Value(finalCash),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory Shift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      cashRegisterId: serializer.fromJson<String>(json['cashRegisterId']),
      initialCash: serializer.fromJson<double>(json['initialCash']),
      finalCash: serializer.fromJson<double?>(json['finalCash']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'cashRegisterId': serializer.toJson<String>(cashRegisterId),
      'initialCash': serializer.toJson<double>(initialCash),
      'finalCash': serializer.toJson<double?>(finalCash),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  Shift copyWith(
          {String? id,
          String? employeeId,
          String? cashRegisterId,
          double? initialCash,
          Value<double?> finalCash = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent()}) =>
      Shift(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        cashRegisterId: cashRegisterId ?? this.cashRegisterId,
        initialCash: initialCash ?? this.initialCash,
        finalCash: finalCash.present ? finalCash.value : this.finalCash,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
      );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      cashRegisterId: data.cashRegisterId.present
          ? data.cashRegisterId.value
          : this.cashRegisterId,
      initialCash:
          data.initialCash.present ? data.initialCash.value : this.initialCash,
      finalCash: data.finalCash.present ? data.finalCash.value : this.finalCash,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('initialCash: $initialCash, ')
          ..write('finalCash: $finalCash, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, cashRegisterId, initialCash,
      finalCash, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.cashRegisterId == this.cashRegisterId &&
          other.initialCash == this.initialCash &&
          other.finalCash == this.finalCash &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> cashRegisterId;
  final Value<double> initialCash;
  final Value<double?> finalCash;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.cashRegisterId = const Value.absent(),
    this.initialCash = const Value.absent(),
    this.finalCash = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required String employeeId,
    required String cashRegisterId,
    required double initialCash,
    this.finalCash = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        employeeId = Value(employeeId),
        cashRegisterId = Value(cashRegisterId),
        initialCash = Value(initialCash);
  static Insertable<Shift> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? cashRegisterId,
    Expression<double>? initialCash,
    Expression<double>? finalCash,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (cashRegisterId != null) 'cash_register_id': cashRegisterId,
      if (initialCash != null) 'initial_cash': initialCash,
      if (finalCash != null) 'final_cash': finalCash,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith(
      {Value<String>? id,
      Value<String>? employeeId,
      Value<String>? cashRegisterId,
      Value<double>? initialCash,
      Value<double?>? finalCash,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? rowid}) {
    return ShiftsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      initialCash: initialCash ?? this.initialCash,
      finalCash: finalCash ?? this.finalCash,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (cashRegisterId.present) {
      map['cash_register_id'] = Variable<String>(cashRegisterId.value);
    }
    if (initialCash.present) {
      map['initial_cash'] = Variable<double>(initialCash.value);
    }
    if (finalCash.present) {
      map['final_cash'] = Variable<double>(finalCash.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('cashRegisterId: $cashRegisterId, ')
          ..write('initialCash: $initialCash, ')
          ..write('finalCash: $finalCash, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BreaksTable extends Breaks with TableInfo<$BreaksTable, Break> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shiftIdMeta =
      const VerificationMeta('shiftId');
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
      'shift_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES shifts (id)'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, shiftId, startedAt, endedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breaks';
  @override
  VerificationContext validateIntegrity(Insertable<Break> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(_shiftIdMeta,
          shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta));
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Break map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Break(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shiftId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
    );
  }

  @override
  $BreaksTable createAlias(String alias) {
    return $BreaksTable(attachedDatabase, alias);
  }
}

class Break extends DataClass implements Insertable<Break> {
  final String id;
  final String shiftId;
  final DateTime startedAt;
  final DateTime? endedAt;
  const Break(
      {required this.id,
      required this.shiftId,
      required this.startedAt,
      this.endedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    return map;
  }

  BreaksCompanion toCompanion(bool nullToAbsent) {
    return BreaksCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
    );
  }

  factory Break.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Break(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
    };
  }

  Break copyWith(
          {String? id,
          String? shiftId,
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent()}) =>
      Break(
        id: id ?? this.id,
        shiftId: shiftId ?? this.shiftId,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
      );
  Break copyWithCompanion(BreaksCompanion data) {
    return Break(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Break(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shiftId, startedAt, endedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Break &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt);
}

class BreaksCompanion extends UpdateCompanion<Break> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> rowid;
  const BreaksCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreaksCompanion.insert({
    required String id,
    required String shiftId,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        shiftId = Value(shiftId);
  static Insertable<Break> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreaksCompanion copyWith(
      {Value<String>? id,
      Value<String>? shiftId,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? rowid}) {
    return BreaksCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreaksCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeIdMeta =
      const VerificationMeta('employeeId');
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
      'employee_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES employees (id)'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventType, employeeId, metadata, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(Insertable<AuditEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
          _employeeIdMeta,
          employeeId.isAcceptableOrUnknown(
              data['employee_id']!, _employeeIdMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  final String id;
  final String eventType;
  final String? employeeId;
  final String? metadata;
  final DateTime createdAt;
  const AuditEvent(
      {required this.id,
      required this.eventType,
      this.employeeId,
      this.metadata,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'employeeId': serializer.toJson<String?>(employeeId),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEvent copyWith(
          {String? id,
          String? eventType,
          Value<String?> employeeId = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          DateTime? createdAt}) =>
      AuditEvent(
        id: id ?? this.id,
        eventType: eventType ?? this.eventType,
        employeeId: employeeId.present ? employeeId.value : this.employeeId,
        metadata: metadata.present ? metadata.value : this.metadata,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      employeeId:
          data.employeeId.present ? data.employeeId.value : this.employeeId,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('employeeId: $employeeId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventType, employeeId, metadata, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.employeeId == this.employeeId &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<String?> employeeId;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    required String eventType,
    this.employeeId = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eventType = Value(eventType);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<String>? employeeId,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (employeeId != null) 'employee_id': employeeId,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? eventType,
      Value<String?>? employeeId,
      Value<String?>? metadata,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      employeeId: employeeId ?? this.employeeId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('employeeId: $employeeId, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CashRegistersTable cashRegisters = $CashRegistersTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $BreaksTable breaks = $BreaksTable(this);
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [employees, cashRegisters, shifts, breaks, auditEvents];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$EmployeesTableCreateCompanionBuilder = EmployeesCompanion Function({
  required String id,
  required String name,
  required String lastName,
  Value<String?> email,
  Value<String?> phone,
  required String emergencyPhone,
  required String role,
  required String pinHash,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$EmployeesTableUpdateCompanionBuilder = EmployeesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> lastName,
  Value<String?> email,
  Value<String?> phone,
  Value<String> emergencyPhone,
  Value<String> role,
  Value<String> pinHash,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName:
              $_aliasNameGenerator(db.employees.id, db.shifts.employeeId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AuditEventsTable, List<AuditEvent>>
      _auditEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.auditEvents,
          aliasName:
              $_aliasNameGenerator(db.employees.id, db.auditEvents.employeeId));

  $$AuditEventsTableProcessedTableManager get auditEventsRefs {
    final manager = $$AuditEventsTableTableManager($_db, $_db.auditEvents)
        .filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> auditEventsRefs(
      Expression<bool> Function($$AuditEventsTableFilterComposer f) f) {
    final $$AuditEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditEvents,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditEventsTableFilterComposer(
              $db: $db,
              $table: $db.auditEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get emergencyPhone => $composableBuilder(
      column: $table.emergencyPhone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> auditEventsRefs<T extends Object>(
      Expression<T> Function($$AuditEventsTableAnnotationComposer a) f) {
    final $$AuditEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.auditEvents,
        getReferencedColumn: (t) => t.employeeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AuditEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.auditEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmployeesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function({bool shiftsRefs, bool auditEventsRefs})> {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> emergencyPhone = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion(
            id: id,
            name: name,
            lastName: lastName,
            email: email,
            phone: phone,
            emergencyPhone: emergencyPhone,
            role: role,
            pinHash: pinHash,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String lastName,
            Value<String?> email = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            required String emergencyPhone,
            required String role,
            required String pinHash,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmployeesCompanion.insert(
            id: id,
            name: name,
            lastName: lastName,
            email: email,
            phone: phone,
            emergencyPhone: emergencyPhone,
            role: role,
            pinHash: pinHash,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EmployeesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shiftsRefs = false, auditEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (shiftsRefs) db.shifts,
                if (auditEventsRefs) db.auditEvents
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<Employee, $EmployeesTable, Shift>(
                        currentTable: table,
                        referencedTable:
                            $$EmployeesTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .shiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.employeeId == item.id),
                        typedResults: items),
                  if (auditEventsRefs)
                    await $_getPrefetchedData<Employee, $EmployeesTable,
                            AuditEvent>(
                        currentTable: table,
                        referencedTable: $$EmployeesTableReferences
                            ._auditEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmployeesTableReferences(db, table, p0)
                                .auditEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.employeeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EmployeesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmployeesTable,
    Employee,
    $$EmployeesTableFilterComposer,
    $$EmployeesTableOrderingComposer,
    $$EmployeesTableAnnotationComposer,
    $$EmployeesTableCreateCompanionBuilder,
    $$EmployeesTableUpdateCompanionBuilder,
    (Employee, $$EmployeesTableReferences),
    Employee,
    PrefetchHooks Function({bool shiftsRefs, bool auditEventsRefs})>;
typedef $$CashRegistersTableCreateCompanionBuilder = CashRegistersCompanion
    Function({
  required String id,
  required String name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$CashRegistersTableUpdateCompanionBuilder = CashRegistersCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CashRegistersTableReferences
    extends BaseReferences<_$AppDatabase, $CashRegistersTable, CashRegister> {
  $$CashRegistersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.shifts,
          aliasName: $_aliasNameGenerator(
              db.cashRegisters.id, db.shifts.cashRegisterId));

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager($_db, $_db.shifts).filter(
        (f) => f.cashRegisterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CashRegistersTableFilterComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> shiftsRefs(
      Expression<bool> Function($$ShiftsTableFilterComposer f) f) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashRegisterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CashRegistersTableOrderingComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CashRegistersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashRegistersTable> {
  $$CashRegistersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
      Expression<T> Function($$ShiftsTableAnnotationComposer a) f) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.cashRegisterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CashRegistersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashRegistersTable,
    CashRegister,
    $$CashRegistersTableFilterComposer,
    $$CashRegistersTableOrderingComposer,
    $$CashRegistersTableAnnotationComposer,
    $$CashRegistersTableCreateCompanionBuilder,
    $$CashRegistersTableUpdateCompanionBuilder,
    (CashRegister, $$CashRegistersTableReferences),
    CashRegister,
    PrefetchHooks Function({bool shiftsRefs})> {
  $$CashRegistersTableTableManager(_$AppDatabase db, $CashRegistersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashRegistersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashRegistersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashRegistersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CashRegistersCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CashRegistersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shiftsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (shiftsRefs) db.shifts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (shiftsRefs)
                    await $_getPrefetchedData<CashRegister, $CashRegistersTable,
                            Shift>(
                        currentTable: table,
                        referencedTable:
                            $$CashRegistersTableReferences._shiftsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CashRegistersTableReferences(db, table, p0)
                                .shiftsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.cashRegisterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CashRegistersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CashRegistersTable,
    CashRegister,
    $$CashRegistersTableFilterComposer,
    $$CashRegistersTableOrderingComposer,
    $$CashRegistersTableAnnotationComposer,
    $$CashRegistersTableCreateCompanionBuilder,
    $$CashRegistersTableUpdateCompanionBuilder,
    (CashRegister, $$CashRegistersTableReferences),
    CashRegister,
    PrefetchHooks Function({bool shiftsRefs})>;
typedef $$ShiftsTableCreateCompanionBuilder = ShiftsCompanion Function({
  required String id,
  required String employeeId,
  required String cashRegisterId,
  required double initialCash,
  Value<double?> finalCash,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$ShiftsTableUpdateCompanionBuilder = ShiftsCompanion Function({
  Value<String> id,
  Value<String> employeeId,
  Value<String> cashRegisterId,
  Value<double> initialCash,
  Value<double?> finalCash,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias($_aliasNameGenerator(db.shifts.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CashRegistersTable _cashRegisterIdTable(_$AppDatabase db) =>
      db.cashRegisters.createAlias(
          $_aliasNameGenerator(db.shifts.cashRegisterId, db.cashRegisters.id));

  $$CashRegistersTableProcessedTableManager get cashRegisterId {
    final $_column = $_itemColumn<String>('cash_register_id')!;

    final manager = $$CashRegistersTableTableManager($_db, $_db.cashRegisters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cashRegisterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BreaksTable, List<Break>> _breaksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.breaks,
          aliasName: $_aliasNameGenerator(db.shifts.id, db.breaks.shiftId));

  $$BreaksTableProcessedTableManager get breaksRefs {
    final manager = $$BreaksTableTableManager($_db, $_db.breaks)
        .filter((f) => f.shiftId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_breaksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalCash => $composableBuilder(
      column: $table.finalCash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableFilterComposer get cashRegisterId {
    final $$CashRegistersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableFilterComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> breaksRefs(
      Expression<bool> Function($$BreaksTableFilterComposer f) f) {
    final $$BreaksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.breaks,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BreaksTableFilterComposer(
              $db: $db,
              $table: $db.breaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalCash => $composableBuilder(
      column: $table.finalCash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableOrderingComposer get cashRegisterId {
    final $$CashRegistersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableOrderingComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get initialCash => $composableBuilder(
      column: $table.initialCash, builder: (column) => column);

  GeneratedColumn<double> get finalCash =>
      $composableBuilder(column: $table.finalCash, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CashRegistersTableAnnotationComposer get cashRegisterId {
    final $$CashRegistersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cashRegisterId,
        referencedTable: $db.cashRegisters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashRegistersTableAnnotationComposer(
              $db: $db,
              $table: $db.cashRegisters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> breaksRefs<T extends Object>(
      Expression<T> Function($$BreaksTableAnnotationComposer a) f) {
    final $$BreaksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.breaks,
        getReferencedColumn: (t) => t.shiftId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BreaksTableAnnotationComposer(
              $db: $db,
              $table: $db.breaks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ShiftsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool employeeId, bool cashRegisterId, bool breaksRefs})> {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> employeeId = const Value.absent(),
            Value<String> cashRegisterId = const Value.absent(),
            Value<double> initialCash = const Value.absent(),
            Value<double?> finalCash = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsCompanion(
            id: id,
            employeeId: employeeId,
            cashRegisterId: cashRegisterId,
            initialCash: initialCash,
            finalCash: finalCash,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String employeeId,
            required String cashRegisterId,
            required double initialCash,
            Value<double?> finalCash = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShiftsCompanion.insert(
            id: id,
            employeeId: employeeId,
            cashRegisterId: cashRegisterId,
            initialCash: initialCash,
            finalCash: finalCash,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ShiftsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {employeeId = false,
              cashRegisterId = false,
              breaksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (breaksRefs) db.breaks],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$ShiftsTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._employeeIdTable(db).id,
                  ) as T;
                }
                if (cashRegisterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cashRegisterId,
                    referencedTable:
                        $$ShiftsTableReferences._cashRegisterIdTable(db),
                    referencedColumn:
                        $$ShiftsTableReferences._cashRegisterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (breaksRefs)
                    await $_getPrefetchedData<Shift, $ShiftsTable, Break>(
                        currentTable: table,
                        referencedTable:
                            $$ShiftsTableReferences._breaksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ShiftsTableReferences(db, table, p0).breaksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.shiftId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ShiftsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShiftsTable,
    Shift,
    $$ShiftsTableFilterComposer,
    $$ShiftsTableOrderingComposer,
    $$ShiftsTableAnnotationComposer,
    $$ShiftsTableCreateCompanionBuilder,
    $$ShiftsTableUpdateCompanionBuilder,
    (Shift, $$ShiftsTableReferences),
    Shift,
    PrefetchHooks Function(
        {bool employeeId, bool cashRegisterId, bool breaksRefs})>;
typedef $$BreaksTableCreateCompanionBuilder = BreaksCompanion Function({
  required String id,
  required String shiftId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});
typedef $$BreaksTableUpdateCompanionBuilder = BreaksCompanion Function({
  Value<String> id,
  Value<String> shiftId,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> rowid,
});

final class $$BreaksTableReferences
    extends BaseReferences<_$AppDatabase, $BreaksTable, Break> {
  $$BreaksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts
      .createAlias($_aliasNameGenerator(db.breaks.shiftId, db.shifts.id));

  $$ShiftsTableProcessedTableManager get shiftId {
    final $_column = $_itemColumn<String>('shift_id')!;

    final manager = $$ShiftsTableTableManager($_db, $_db.shifts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BreaksTableFilterComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableFilterComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableOrderingComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreaksTable> {
  $$BreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shiftId,
        referencedTable: $db.shifts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ShiftsTableAnnotationComposer(
              $db: $db,
              $table: $db.shifts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BreaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BreaksTable,
    Break,
    $$BreaksTableFilterComposer,
    $$BreaksTableOrderingComposer,
    $$BreaksTableAnnotationComposer,
    $$BreaksTableCreateCompanionBuilder,
    $$BreaksTableUpdateCompanionBuilder,
    (Break, $$BreaksTableReferences),
    Break,
    PrefetchHooks Function({bool shiftId})> {
  $$BreaksTableTableManager(_$AppDatabase db, $BreaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> shiftId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreaksCompanion(
            id: id,
            shiftId: shiftId,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String shiftId,
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreaksCompanion.insert(
            id: id,
            shiftId: shiftId,
            startedAt: startedAt,
            endedAt: endedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BreaksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({shiftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shiftId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shiftId,
                    referencedTable: $$BreaksTableReferences._shiftIdTable(db),
                    referencedColumn:
                        $$BreaksTableReferences._shiftIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BreaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BreaksTable,
    Break,
    $$BreaksTableFilterComposer,
    $$BreaksTableOrderingComposer,
    $$BreaksTableAnnotationComposer,
    $$BreaksTableCreateCompanionBuilder,
    $$BreaksTableUpdateCompanionBuilder,
    (Break, $$BreaksTableReferences),
    Break,
    PrefetchHooks Function({bool shiftId})>;
typedef $$AuditEventsTableCreateCompanionBuilder = AuditEventsCompanion
    Function({
  required String id,
  required String eventType,
  Value<String?> employeeId,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AuditEventsTableUpdateCompanionBuilder = AuditEventsCompanion
    Function({
  Value<String> id,
  Value<String> eventType,
  Value<String?> employeeId,
  Value<String?> metadata,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$AuditEventsTableReferences
    extends BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent> {
  $$AuditEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
          $_aliasNameGenerator(db.auditEvents.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<String>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager($_db, $_db.employees)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableFilterComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableOrderingComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.employeeId,
        referencedTable: $db.employees,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmployeesTableAnnotationComposer(
              $db: $db,
              $table: $db.employees,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AuditEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, $$AuditEventsTableReferences),
    AuditEvent,
    PrefetchHooks Function({bool employeeId})> {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String?> employeeId = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion(
            id: id,
            eventType: eventType,
            employeeId: employeeId,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String eventType,
            Value<String?> employeeId = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditEventsCompanion.insert(
            id: id,
            eventType: eventType,
            employeeId: employeeId,
            metadata: metadata,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AuditEventsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (employeeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.employeeId,
                    referencedTable:
                        $$AuditEventsTableReferences._employeeIdTable(db),
                    referencedColumn:
                        $$AuditEventsTableReferences._employeeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AuditEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditEventsTable,
    AuditEvent,
    $$AuditEventsTableFilterComposer,
    $$AuditEventsTableOrderingComposer,
    $$AuditEventsTableAnnotationComposer,
    $$AuditEventsTableCreateCompanionBuilder,
    $$AuditEventsTableUpdateCompanionBuilder,
    (AuditEvent, $$AuditEventsTableReferences),
    AuditEvent,
    PrefetchHooks Function({bool employeeId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$CashRegistersTableTableManager get cashRegisters =>
      $$CashRegistersTableTableManager(_db, _db.cashRegisters);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$BreaksTableTableManager get breaks =>
      $$BreaksTableTableManager(_db, _db.breaks);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
}
</file>

<file path="lib/features/employees/presentation/pages/dashboard_page.dart">
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/employee_entity.dart';
import '../../../auth/domain/entities/shift_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

class DashboardPage extends StatelessWidget {
  final EmployeeEntity employee;
  final ShiftEntity shift;

  const DashboardPage({
    super.key,
    required this.employee,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PRIMO V2 - Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.lock_outline),
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              tooltip: 'Bloquear Pantalla',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.fullName,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  employee.role.toValue(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.deepPurple,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        'Turno Iniciado',
                        _formatDateTime(shift.startedAt),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        context,
                        'Fondo Inicial',
                        shift.initialCash.toFormattedString(),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        context,
                        'Duración',
                        _formatDuration(shift.duration),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Action buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.coffee,
                      title: 'Iniciar Pausa',
                      color: Colors.orange,
                      onTap: () {
                        context.read<AuthBloc>().add(StartBreakRequested(shift.id));
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.shopping_cart,
                      title: 'Ventas',
                      color: Colors.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Módulo de Ventas próximamente')),
                        );
                      },
                    ),
                    if (employee.role.canManageEmployees)
                      _buildActionCard(
                        context,
                        icon: Icons.people,
                        title: 'Empleados',
                        color: Colors.blue,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Módulo de Empleados próximamente')),
                          );
                        },
                      ),
                    _buildActionCard(
                      context,
                      icon: Icons.logout,
                      title: 'Cerrar Turno',
                      color: Colors.red,
                      onTap: () => _showClockOutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClockOutDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar Turno'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa el monto final en caja:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto Final',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final finalCash = double.tryParse(controller.text) ?? 0.0;
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(
                    ClockOutRequested(
                      shiftId: shift.id,
                      finalCash: finalCash,
                    ),
                  );
            },
            child: const Text('Cerrar Turno'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
</file>

<file path="lib/main.dart">
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initDependencies();
  
  runApp(const PrimoApp());
}

class PrimoApp extends StatelessWidget {
  const PrimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp(
        title: 'PRIMO V2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
</file>

<file path="lib/features/auth/data/datasources/auth_local_datasource.dart">
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../database/data/app_database.dart';
import 'package:uuid/uuid.dart';

abstract class AuthLocalDataSource {
  Future<Employee> loginWithPin(String pin);
  Future<Shift> clockIn({
    required String employeeId,
    required double initialCash,
  });
  Future<void> clockOut({
    required String shiftId,
    required double finalCash,
  });
  Future<Shift?> getActiveShift(String employeeId);
  Future<void> startBreak(String shiftId);
  Future<void> endBreak(String shiftId);
  Future<bool> hasActiveBreak(String shiftId);
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;
  final Logger logger = Logger();

  AuthLocalDataSourceImpl({
    required this.database,
    required this.uuid,
  });

  @override
  Future<Employee> loginWithPin(String pin) async {
    try {
      final pinHash = Pin.fromPlainText(pin).toHash();
      final employee = await database.getEmployeeByPinHash(pinHash);

      if (employee == null) {
        await logAuditEvent(
          eventType: 'login_failed',
          metadata: 'Invalid PIN attempt',
        );
        throw AuthException('Invalid PIN');
      }

      if (!employee.isActive) {
        await logAuditEvent(
          eventType: 'login_failed',
          employeeId: employee.id,
          metadata: 'Inactive employee',
        );
        throw AuthException('Employee is inactive');
      }

      await logAuditEvent(
        eventType: 'login_success',
        employeeId: employee.id,
      );

      return employee;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw DatabaseException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<Shift> clockIn({
    required String employeeId,
    required double initialCash,
  }) async {
    try {
      final shiftId = uuid.v4();
      
      await database.insertShift(
        ShiftsCompanion.insert(
          id: shiftId,
          employeeId: employeeId,
          cashRegisterId: 'default-register',
          initialCash: initialCash,
        ),
      );

      await logAuditEvent(
        eventType: 'clock_in',
        employeeId: employeeId,
        metadata: 'Initial cash: \$$initialCash',
      );

      final shift = await database.getActiveShiftByEmployeeId(employeeId);
      if (shift == null) {
        throw DatabaseException('Failed to retrieve created shift');
      }

      return shift;
    } catch (e) {
      throw DatabaseException('Clock-in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> clockOut({
    required String shiftId,
    required double finalCash,
  }) async {
    try {
      await database.closeShift(shiftId, finalCash);

      await logAuditEvent(
        eventType: 'clock_out',
        metadata: 'Shift ID: $shiftId, Final cash: \$$finalCash',
      );
    } catch (e) {
      throw DatabaseException('Clock-out failed: ${e.toString()}');
    }
  }

  @override
  Future<Shift?> getActiveShift(String employeeId) async {
    try {
      return await database.getActiveShiftByEmployeeId(employeeId);
    } catch (e) {
      throw DatabaseException('Failed to get active shift: ${e.toString()}');
    }
  }

  @override
  Future<void> startBreak(String shiftId) async {
    try {
      final breakId = uuid.v4();
      
      await database.insertBreak(
        BreaksCompanion.insert(
          id: breakId,
          shiftId: shiftId,
        ),
      );

      await logAuditEvent(
        eventType: 'break_start',
        metadata: 'Shift ID: $shiftId',
      );
    } catch (e) {
      throw DatabaseException('Start break failed: ${e.toString()}');
    }
  }

  @override
  Future<void> endBreak(String shiftId) async {
    try {
      final activeBreak = await database.getActiveBreakByShiftId(shiftId);
      
      if (activeBreak == null) {
        throw ValidationException('No active break found');
      }

      await database.endBreak(activeBreak.id);

      await logAuditEvent(
        eventType: 'break_end',
        metadata: 'Shift ID: $shiftId',
      );
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('End break failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasActiveBreak(String shiftId) async {
    try {
      final activeBreak = await database.getActiveBreakByShiftId(shiftId);
      return activeBreak != null;
    } catch (e) {
      throw DatabaseException('Check active break failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  }) async {
    try {
      await database.insertAuditEvent(
        AuditEventsCompanion.insert(
          id: uuid.v4(),
          eventType: eventType,
          employeeId: Value(employeeId),
          metadata: Value(metadata),
        ),
      );
    } catch (e) {
      // Don't throw on audit failures to avoid breaking main operations
      logger.e('Audit event failed: ${e.toString()}');
    }
  }
}
</file>

<file path="pubspec.yaml">
name: primo_v2
description: Sistema POS con arquitectura hexagonal, BLoC y Drift
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  bloc_concurrency: ^0.2.2

  # Dependency Injection
  get_it: ^7.6.4

  # Database (Drift/SQLite)
  drift: ^2.13.2
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3

  # Functional Programming
  dartz: ^0.10.1

  # Security
  crypto: ^3.0.3

  # Utilities
  logger: ^2.0.2+1
  uuid: ^4.2.2

  # UI
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.3
  
  # Code Generation
  drift_dev: ^2.13.2
  build_runner: ^2.4.6
  
  # Testing
  bloc_test: ^9.1.5
  mocktail: ^1.0.1

flutter:
  uses-material-design: true
</file>

</files>

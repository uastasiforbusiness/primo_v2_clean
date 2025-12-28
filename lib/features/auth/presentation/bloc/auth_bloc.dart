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

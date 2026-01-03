import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/login_with_pin_usecase.dart';
import '../../../../features/employees/domain/usecases/get_active_work_shift_usecase.dart';
import '../../../../features/employees/domain/usecases/clock_in_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPinUseCase loginWithPinUseCase;
  final GetActiveWorkShiftUseCase getActiveWorkShiftUseCase;
  final LaborClockInUseCase clockInUseCase;
  final Logger logger = Logger();

  AuthBloc({
    required this.loginWithPinUseCase,
    required this.getActiveWorkShiftUseCase,
    required this.clockInUseCase,
  }) : super(const AuthInitial()) {
    on<LoginWithPinRequested>(_onLoginWithPinRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<ConfirmClockInRequested>(_onConfirmClockInRequested);

    logger.i('🔄 AuthBloc initialized');
  }

  Future<void> _onLoginWithPinRequested(
    LoginWithPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    logger.i('🔐 Login attempt with PIN');
    emit(const AuthLoading());

    final result = await loginWithPinUseCase(event.pin);

    await result.fold(
      (failure) async {
        logger.e('❌ Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (employee) async {
        logger.i('✅ PIN correct for employee: ${employee.id}. Checking work shift...');

        // CHECK CLOCK-IN STATUS
        final shiftResult = await getActiveWorkShiftUseCase(
          GetActiveWorkShiftParams(employeeId: employee.id),
        );

        shiftResult.fold(
          (failure) => emit(AuthError('Error checking work shift: ${failure.message}')),
          (shift) {
            if (shift == null) {
              logger.i('⚠️ Employee ${employee.id} is NOT clocked in.');
              emit(AuthClockInRequired(employee: employee));
            } else {
              logger.i('✅ Employee ${employee.id} is clocked in. Access granted.');
              emit(AuthAuthenticated(employee: employee, workShift: shift));
            }
          },
        );
      },
    );
  }

  Future<void> _onConfirmClockInRequested(
    ConfirmClockInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await clockInUseCase(
      LaborClockInParams(employeeId: event.employee.id),
    );

    result.fold(
      (failure) => emit(AuthError('Clock-in failed: ${failure.message}')),
      (shift) {
        logger.i('✅ Clock-in successful for employee: ${event.employee.id}');
        emit(AuthAuthenticated(employee: event.employee, workShift: shift));
      },
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    logger.i('🔐 Logout requested');
    emit(const AuthUnauthenticated());
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    logger.i('🔍 Checking auth status');
    // Aquí podrías implementar persistencia de sesión si fuera necesario
    // Por ahora, iniciamos como no autenticado
    emit(const AuthUnauthenticated());
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/usecases/login_with_pin_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPinUseCase loginWithPinUseCase;
  final Logger logger = Logger();

  AuthBloc({
    required this.loginWithPinUseCase,
  }) : super(const AuthInitial()) {
    on<LoginWithPinRequested>(_onLoginWithPinRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    
    logger.i('🔄 AuthBloc initialized');
  }

  Future<void> _onLoginWithPinRequested(
    LoginWithPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    logger.i('🔐 Login attempt with PIN: ${event.pin}');
    emit(const AuthLoading());

    final result = await loginWithPinUseCase(event.pin);

    result.fold(
      (failure) {
        logger.e('❌ Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (employee) {
        logger.i('✅ Login successful for employee: ${employee.id}');
        emit(AuthAuthenticated(employee: employee));
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

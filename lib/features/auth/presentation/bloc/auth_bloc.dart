import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_with_pin_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPinUseCase loginWithPinUseCase;

  AuthBloc({
    required this.loginWithPinUseCase,
  }) : super(const AuthInitial()) {
    on<LoginWithPinRequested>(_onLoginWithPinRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginWithPinRequested(
    LoginWithPinRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithPinUseCase(event.pin);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (employee) => emit(AuthAuthenticated(employee: employee)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthUnauthenticated());
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    // Aquí podrías implementar persistencia de sesión si fuera necesario
    // Por ahora, iniciamos como no autenticado
    emit(const AuthUnauthenticated());
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:primo_v2/core/error/failures.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/features/auth/domain/entities/employee_entity.dart';
import 'package:primo_v2/features/auth/domain/usecases/login_with_pin_usecase.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_event.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';

class MockLoginWithPinUseCase extends Mock implements LoginWithPinUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginWithPinUseCase mockLoginWithPinUseCase;

  const testEmployee = EmployeeEntity(
    id: 'test-employee-id',
    name: 'Test Employee',
    role: Role.cashier,
    isActive: true,
  );

  setUp(() {
    mockLoginWithPinUseCase = MockLoginWithPinUseCase();
    authBloc = AuthBloc(loginWithPinUseCase: mockLoginWithPinUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login is successful',
      build: () {
        when(mockLoginWithPinUseCase('1234')).thenAnswer((_) async => const Right(testEmployee));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginWithPinRequested('1234')),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(employee: testEmployee),
      ],
      verify: (_) {
        verify(mockLoginWithPinUseCase('1234')).called(1);
      },
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockLoginWithPinUseCase('wrong'))
            .thenAnswer((_) async => const Left(AuthFailure(message: 'Invalid PIN')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginWithPinRequested('wrong')),
      expect: () => [
        const AuthLoading(),
        const AuthError('Invalid PIN'),
      ],
      verify: (_) {
        verify(mockLoginWithPinUseCase('wrong')).called(1);
      },
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'emits [AuthLoading, AuthError] when PIN format is invalid',
      build: () {
        when(mockLoginWithPinUseCase('123')).thenAnswer(
            (_) async => const Left(ValidationFailure(message: 'PIN must be 4 digits')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginWithPinRequested('123')),
      expect: () => [
        const AuthLoading(),
        const AuthError('PIN must be 4 digits'),
      ],
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'emits [AuthUnauthenticated] when logout is requested',
      build: () => authBloc,
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [const AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthEvent, AuthState>(
      'emits [AuthUnauthenticated] when checking auth status',
      build: () => authBloc,
      act: (bloc) => bloc.add(const CheckAuthStatus()),
      expect: () => [const AuthUnauthenticated()],
    );
  });
}

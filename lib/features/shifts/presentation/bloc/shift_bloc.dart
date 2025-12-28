import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/clock_in_usecase.dart';
import '../../domain/usecases/clock_out_usecase.dart';
import '../../domain/usecases/start_break_usecase.dart';
import '../../domain/usecases/end_break_usecase.dart';
import '../../domain/repositories/shift_repository.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final ClockInUseCase clockInUseCase;
  final ClockOutUseCase clockOutUseCase;
  final StartBreakUseCase startBreakUseCase;
  final EndBreakUseCase endBreakUseCase;
  final ShiftRepository shiftRepository;

  ShiftBloc({
    required this.clockInUseCase,
    required this.clockOutUseCase,
    required this.startBreakUseCase,
    required this.endBreakUseCase,
    required this.shiftRepository,
  }) : super(ShiftInitial()) {
    on<LoadActiveShift>(_onLoadActiveShift);
    on<ClockInRequested>(_onClockInRequested);
    on<ClockOutRequested>(_onClockOutRequested);
    on<StartBreakRequested>(_onStartBreakRequested);
    on<EndBreakRequested>(_onEndBreakRequested);
  }

  Future<void> _onLoadActiveShift(LoadActiveShift event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await shiftRepository.getActiveShift(event.employeeId);

    await result.fold(
      (failure) async => emit(ShiftError(failure.message)),
      (shift) async {
        if (shift != null) {
          final hasBreak = await shiftRepository.hasActiveBreak(shift.id);
          hasBreak.fold(
             (l) => emit(ShiftActive(shift)),
             (isOnBreak) => isOnBreak
                ? emit(ShiftOnBreak(shift))
                : emit(ShiftActive(shift))
          );
        } else {
          emit(ShiftInactive());
        }
      },
    );
  }

  Future<void> _onClockInRequested(ClockInRequested event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await clockInUseCase(
      employeeId: event.employeeId,
      initialCashAmount: event.initialCash,
    );
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) => emit(ShiftActive(shift)),
    );
  }

  Future<void> _onClockOutRequested(ClockOutRequested event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    final result = await clockOutUseCase(
      shiftId: event.shiftId,
      finalCashAmount: event.finalCash,
    );
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (_) => emit(ShiftInactive()),
    );
  }

  Future<void> _onStartBreakRequested(StartBreakRequested event, Emitter<ShiftState> emit) async {
    if (state is! ShiftActive) return;
    final currentShift = (state as ShiftActive).shift;

    final result = await startBreakUseCase(event.shiftId);
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (_) => emit(ShiftOnBreak(currentShift)),
    );
  }

  Future<void> _onEndBreakRequested(EndBreakRequested event, Emitter<ShiftState> emit) async {
    if (state is! ShiftOnBreak) return;
    final currentShift = (state as ShiftOnBreak).shift;

    final result = await endBreakUseCase(event.shiftId);
    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (_) => emit(ShiftActive(currentShift)),
    );
  }
}

import 'package:equatable/equatable.dart';

class BreakEntity extends Equatable {
  final String id;
  final String shiftId;
  final DateTime startedAt;
  final DateTime? endedAt;

  const BreakEntity({
    required this.id,
    required this.shiftId,
    required this.startedAt,
    this.endedAt,
  });

  bool get isActive => endedAt == null;

  @override
  List<Object?> get props => [id, shiftId, startedAt, endedAt];
}

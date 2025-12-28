# PRIMO_V2 - Context Navigation

## Quick Reference

| Layer | Location |
|-------|----------|
| Database Schema | `lib/features/database/data/app_database.dart` |
| Auth BLoC | `lib/features/auth/presentation/bloc/auth_bloc.dart` |
| Shift BLoC | `lib/features/auth/presentation/bloc/shift/shift_bloc.dart` |
| Employee BLoC | `lib/features/employees/presentation/bloc/employee_bloc.dart` |
| DI Container | `lib/di/injection_container.dart` |
| Value Objects | `lib/core/shared_kernel/` |

## Common Commands

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
flutter test

text

## State Management Flow

Widget → Event → BLoC → UseCase → Repository → DataSource (Drift) → Database

text
undefined
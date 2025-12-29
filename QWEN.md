# PRIMO_V2 - Qwen Context

## Project Overview
PRIMO_V2 is a Flutter Point of Sale (POS) system built with modern architecture principles.

## Key Files & Directories

### Core Architecture
- **Database Schema**: `lib/features/database/data/app_database.dart`
- **Dependency Injection**: `lib/di/injection_container.dart`
- **Value Objects**: `lib/core/shared_kernel/`

### State Management
- **Auth BLoC**: `lib/features/auth/presentation/bloc/auth_bloc.dart`
- **Shift BLoC**: `lib/features/auth/presentation/bloc/shift/shift_bloc.dart`
- **Employee BLoC**: `lib/features/employees/presentation/bloc/employee_bloc.dart`

### Architecture Pattern
State Flow: Widget → Event → BLoC → UseCase → Repository → DataSource (Drift) → Database

## Common Commands
- `flutter pub get`
- `flutter pub run build_runner build --delete-conflicting-outputs`
- `flutter run`
- `flutter test`

## Development Guidelines
- Follow BLoC pattern for state management
- Use Value Objects for domain validation
- Maintain clean architecture separation
- Use Drift for local database operations
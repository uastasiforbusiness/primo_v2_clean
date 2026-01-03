# PRIMO V2 Point of Sale System - QWEN Context

## Project Overview

PRIMO V2 is a Flutter-based Point of Sale (POS) system built with modern architecture patterns. It's a comprehensive solution for managing employees, work shifts, cash registers, and audit trails. The application follows clean architecture principles with separation of concerns between data, domain, and presentation layers.

### Key Features
- **Employee Management**: Create, update, delete, and manage employee profiles with roles and PIN authentication
- **Time & Attendance**: Clock-in/clock-out functionality with break tracking
- **Shift Management**: Manage active shifts with initial/final cash amounts
- **Authentication**: PIN-based authentication system
- **Audit Trail**: Comprehensive logging of system events
- **Role-based Access Control**: Different permissions for admin and regular users

### Architecture
- **Clean Architecture**: Clear separation between data, domain, and presentation layers
- **BLoC Pattern**: State management using Flutter BLoC
- **Dependency Injection**: GetIt for managing dependencies
- **Local Database**: Drift (SQLite) for persistent data storage
- **Navigation**: GoRouter for centralized navigation with authentication guards

## Technologies & Dependencies

### Core Dependencies
- Flutter SDK (>=3.0.0 <4.0.0)
- **State Management**: flutter_bloc
- **Database**: drift, sqlite3_flutter_libs, path_provider
- **DI**: get_it
- **Navigation**: go_router
- **Utilities**: equatable, dartz, uuid, logger, crypto, intl

### Architecture Layers
- **Presentation Layer**: UI components and BLoC state management
- **Domain Layer**: Business logic, use cases, and repositories interfaces
- **Data Layer**: Repository implementations, data sources, and models
- **Infrastructure Layer**: Database and external services

## Project Structure

```
lib/
├── config/           # Configuration files (theme, routing)
├── core/             # Core functionality (router, shared kernel)
├── di/               # Dependency injection container
├── features/         # Feature modules
│   ├── audit/        # Audit trail functionality
│   ├── auth/         # Authentication system
│   ├── employees/    # Employee management
│   ├── error/        # Error handling pages
│   ├── settings/     # Settings (placeholder)
│   ├── shifts/       # Shift management
│   └── splash/       # Splash screen
├── infrastructure/   # Infrastructure layer (database)
└── main.dart         # Application entry point
```

## Key Features Breakdown

### Authentication System
- PIN-based authentication
- Multi-step login process (PIN verification → Clock-in check → Access granted)
- Role-based access control (admin vs regular employees)

### Employee Management
- CRUD operations for employee profiles
- PIN management with SHA-256 hashing
- Role assignment (admin, employee)
- Hourly rate tracking

### Shift Management
- Clock-in/clock-out with initial/final cash amounts
- Break tracking (start/end breaks)
- Active shift monitoring
- Cash register assignment

### Audit Trail
- Comprehensive logging of system events
- Event types tracking
- Employee association with events

## Database Schema

The application uses a Drift-based SQLite database with the following tables:

- **Employees**: Employee profiles, PIN hashes, roles, contact info
- **CashRegisters**: Cash register management
- **Shifts**: POS shift management with cash amounts
- **Breaks**: Break tracking during shifts
- **WorkShifts**: Time & attendance tracking
- **AuditEvents**: System audit trail

## Building and Running

### Prerequisites
- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK (compatible with Flutter)

### Setup Commands
```bash
# Install dependencies
flutter pub get

# Generate code (for Drift and other generators)
dart run build_runner build --delete-conflicting-outputs

# Run the application
flutter run

# Run tests
flutter test

# Build for production
flutter build apk    # Android
flutter build ios    # iOS
```

### Development Commands
```bash
# Generate code after making changes to .drift files
dart run build_runner watch

# Run with verbose logging
flutter run --verbose

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## Development Conventions

### Code Structure
- Follow clean architecture principles
- Use BLoC for state management
- Separate concerns into data/domain/presentation layers
- Use meaningful naming conventions
- Write comprehensive tests

### Authentication Flow
1. User enters PIN on login screen
2. System verifies PIN against stored hash
3. Checks if employee needs to clock in
4. Grants access based on authentication and shift status

### Navigation Guards
- Authentication-based route protection
- Shift status-based navigation restrictions
- Role-based access control
- Automatic redirects based on state

### Error Handling
- Comprehensive error states in BLoCs
- User-friendly error messages
- Audit logging for security events
- Graceful degradation for network/database issues

## Key Components

### Main Dependencies
- **drift**: Type-safe SQL database framework
- **flutter_bloc**: State management solution
- **get_it**: Service locator for dependency injection
- **go_router**: Declarative navigation solution
- **logger**: Application logging

### Predefined Data
- Default admin user created on first run (ID: admin-001, PIN: 1234)
- Default cash register created on first run
- Database schema versioning with migration support

## Testing Strategy

The project includes:
- Unit tests for business logic
- Integration tests for data layer
- Widget tests for UI components
- Mocking utilities (mocktail, mockito)

## Common Tasks

### Adding a New Feature
1. Create feature directory under `lib/features/`
2. Implement data/domain/presentation layers
3. Add to dependency injection container
4. Register routes in `AppRouter`
5. Add navigation guards if needed

### Database Changes
1. Modify table definitions in `AppDatabase`
2. Update migration strategy
3. Run build runner to regenerate code
4. Test migration scenarios

### Adding New Routes
1. Define route in `AppRouter`
2. Add navigation guards if needed
3. Create corresponding pages/components
4. Update UI navigation elements

## Security Considerations

- PINs are stored as SHA-256 hashes
- Role-based access control
- Audit logging for security events
- Secure data storage using local database
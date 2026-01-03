# 🚀 Guía de Desarrollo - PRIMO V2

## 🎯 Principios Fundamentales

### 1. Arquitectura Hexagonal
- **Regla de Dependencia:** El código interno puede depender del código externo, pero nunca al revés
- **Capas:** Presentation → Domain → Data
- **Nunca** salts capas o crees dependencias circulares

### 2. Clean Code
- **Funciones pequeñas:** Cada función debe hacer una sola cosa
- **Nombres descriptivos:** Que el código se lea como prosa
- **Evitar abreviaturas:** A menos que sean estándar del dominio
- **Consistencia:** Mantener el mismo estilo en todo el proyecto

### 3. Manejo de Errores
- **Usar Either<Failure, T>:** Para operaciones que pueden fallar
- **Excepciones específicas:** Crear excepciones para diferentes tipos de errores
- **Logging adecuado:** Registrar errores sin exponer información sensible

## 🔧 Patrones de Desarrollo

### 1. Creación de Nuevas Features

#### Estructura de Archivos
```
features/[nombre]/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

#### Flujo de Trabajo
1. **Definir entidades** en `domain/entities/`
2. **Crear repositorio abstracto** en `domain/repositories/`
3. **Implementar casos de uso** en `domain/usecases/`
4. **Crear data source** en `data/datasources/`
5. **Implementar repositorio** en `data/repositories/`
6. **Crear BLoC** en `presentation/bloc/`
7. **Desarrollar UI** en `presentation/pages/` y `presentation/widgets/`

### 2. Manejo de Estado con BLoC

#### Buenas Prácticas
- **Eventos:** Deben ser inmutables y representar acciones específicas
- **Estados:** Deben representar todos los posibles estados de la feature
- **Lógica:** Mantenerla en el BLoC, no en la UI
- **Separación:** No mezclar lógica de negocio con lógica de presentación

#### Ejemplo de BLoC Bien Estructurado

```dart
// Eventos
abstract class FeatureEvent extends Equatable {}
class LoadDataRequested extends FeatureEvent {}
class CreateItemRequested extends FeatureEvent {
  final ItemEntity item;
  CreateItemRequested(this.item);
}

// Estados
abstract class FeatureState extends Equatable {}
class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final List<ItemEntity> items;
  FeatureLoaded(this.items);
}
class FeatureError extends FeatureState {
  final String message;
  FeatureError(this.message);
}

// BLoC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final GetItemsUseCase getItemsUseCase;
  final CreateItemUseCase createItemUseCase;
  
  FeatureBloc({
    required this.getItemsUseCase,
    required this.createItemUseCase,
  }) : super(FeatureInitial()) {
    on<LoadDataRequested>(_onLoadDataRequested);
    on<CreateItemRequested>(_onCreateItemRequested);
  }
  
  Future<void> _onLoadDataRequested(
    LoadDataRequested event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    final result = await getItemsUseCase();
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (items) => emit(FeatureLoaded(items)),
    );
  }
}
```

### 3. Navegación con GoRouter

#### Principios
- **Centralizar** toda la lógica de navegación en `AppRouter`
- **Evitar** navegación directa en widgets
- **Usar** `GoRouterRefreshStream` para navegación reactiva
- **Manejar** estados de carga adecuadamente

#### Patrones de Redirección

```dart
// ✅ BIEN: Lógica centralizada en router
redirect: (context, state) {
  final authState = context.read<AuthBloc>().state;
  
  if (authState is! AuthAuthenticated && state.matchedLocation != '/login') {
    return '/login';
  }
  
  return null;
}

// ❌ MAL: Navegación en widgets
if (state is Authenticated) {
  Navigator.push(context, MaterialPageRoute(builder: ...));
}
```

### 4. Manejo de Dependencias

#### Inyección de Dependencias
- **Usar** `get_it` para inyección de dependencias
- **Registrar** dependencias en `injection_container.dart`
- **Evitar** crear instancias directamente con `new`

#### Ejemplo

```dart
// En injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(loginWithPinUseCase: sl()));
  
  // Use Cases
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
  
  // Repositorios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(localDataSource: sl()));
  
  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(database: sl()));
}

// Uso en widgets
final authBloc = sl<AuthBloc>();
```

## 🧪 Testing

### 1. Pruebas Unitarias
- **Cubrir** todos los casos de uso
- **Mockear** dependencias externas
- **Verificar** estados emitidos por BLoCs

### 2. Pruebas de Widgets
- **Probar** navegación
- **Verificar** renderizado de UI
- **Testear** interacciones

### 3. Pruebas de Integración
- **Testear** flujos completos
- **Verificar** integración entre componentes
- **Probar** escenarios reales

## 📝 Convenciones de Código

### 1. Nomenclatura
- **Clases:** PascalCase (`AuthBloc`, `LoginPage`)
- **Variables y métodos:** camelCase (`loginWithPin`, `employeeId`)
- **Constantes:** SCREAMING_SNAKE_CASE (`DEFAULT_PIN`)
- **Archivos:** snake_case (`auth_bloc.dart`)

### 2. Estructura de Código
- **Orden en clases:** Propiedades → Constructor → Métodos públicos → Métodos privados
- **Documentación:** Comentar lógica compleja y métodos públicos
- **Imports:** Agrupar por tipo y ordenar alfabéticamente

### 3. Manejo de Errores
- **Validar** entradas antes de procesar
- **Usar** tipos específicos de errores
- **Proporcionar** mensajes de error útiles
- **Registrar** errores para depuración

## 🚨 Problemas Comunes y Soluciones

### 1. Condiciones de Carrera
**Problema:** Múltiples BLoCs actualizando estado simultáneamente

**Solución:**
```dart
// Usar Future.microtask para sincronización
context.read<BlocA>().add(EventA());
Future.microtask(() {
  context.read<BlocB>().add(EventB());
});
```

### 2. Navegación Infinitas
**Problema:** Bucles de redirección en GoRouter

**Solución:**
```dart
// Verificar estado actual antes de redirigir
if (currentLocation == targetLocation) {
  return null; // No redirigir
}
```

### 3. Estados Inconsistentes
**Problema:** UI no se actualiza correctamente

**Solución:**
```dart
// Asegurar que todos los estados sean inmutables
// Usar Equatable para comparación de estados
class MyState extends Equatable {
  final String data;
  const MyState(this.data);
  
  @override
  List<Object?> get props => [data];
}
```

## 🎓 Recursos de Aprendizaje

- **BLoC:** https://bloclibrary.dev/
- **Clean Architecture:** https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **Dartz:** https://pub.dev/packages/dartz
- **GoRouter:** https://pub.dev/packages/go_router
- **Drift:** https://drift.simonbinder.eu/

## 🤝 Colaboración

- **Code Reviews:** Siempre revisar código antes de merge
- **Pull Requests:** Describir cambios y propósito
- **Documentación:** Actualizar documentación cuando se añaden features
- **Consistencia:** Seguir las convenciones establecidas

**¡Recuerda:** El código es leído muchas más veces de las que es escrito! 📖
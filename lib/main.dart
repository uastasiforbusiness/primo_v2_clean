import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo_v2/config/theme/app_theme.dart'; // Ajusta si tu ruta de tema es diferente
import 'package:primo_v2/core/router/app_router.dart';
import 'package:primo_v2/di/injection_container.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_event.dart'; // Importante para CheckAuthStatus
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await initDependencies();

  // Validar integridad (Opcional, si tienes esa función, déjala aquí)
  // await _validateDatabaseIntegrity();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const CheckAuthStatus()),
        ),
        BlocProvider(
          create: (_) => sl<ShiftBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'PRIMO V2 POS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Asegúrate de tener tu tema definido
        routerConfig: AppRouter.router,
      ),
    );
  }
}

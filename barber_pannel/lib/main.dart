import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_themes.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';
import 'package:barber_pannel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(usecase: RegisterBarberUseCase(repository: RegisterBarberRepository())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fresh Fide Business',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

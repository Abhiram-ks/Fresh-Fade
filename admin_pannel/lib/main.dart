import 'package:admin_pannel/core/di/service_locator.dart';
import 'package:admin_pannel/core/routes/routes.dart';
import 'package:admin_pannel/core/themes/app_themes.dart';
import 'package:admin_pannel/features/presentation/state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'package:admin_pannel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (context) => sl<ServiceMangementBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fresh Fide in',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

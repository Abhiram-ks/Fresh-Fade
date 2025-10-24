import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/core/themes/app_themes.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';
import 'package:barber_pannel/firebase_options.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  await init(); // Initialize all dependencies
  CloudinaryConfig.initialize(); // Initialize Cloudinary
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppPalette.whiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),

      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => sl<RegisterBloc>())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fresh Fade Business',
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}

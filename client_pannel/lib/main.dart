
import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/core/themes/app_themes.dart';
import 'package:client_pannel/features/app/domain/usecase/get_location_usecase.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/location_bloc/location_bloc.dart';

import 'package:client_pannel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'core/di/di.dart';
import 'service/cloudinary/cloudinary_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  CloudinaryConfig.initialize();

  // Request location permission at app startup
  await _requestLocationPermission();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}


Future<void> _requestLocationPermission() async {
  try {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }
  } catch (e) {
    debugPrint('Error requesting location permission: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MultiBlocProvider(
        providers: [
          
        BlocProvider(create: (context) => LocationBloc(GetLocationUseCase())..add(GetCurrentLocationEvent())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fresh Fade',
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}

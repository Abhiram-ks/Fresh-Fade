import 'package:client_pannel/core/common/custom_chat_window_textfiled.dart' show EmojiPickerCubit;
import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/core/themes/app_themes.dart';
import 'package:client_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:client_pannel/features/app/data/datasource/rating_remote_datasource.dart';
import 'package:client_pannel/features/app/data/repo/barber_repo_impl.dart';
import 'package:client_pannel/features/app/domain/repo/barber_repo.dart';
import 'package:client_pannel/features/app/domain/usecase/get_all_barbers_usecase.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart' show FetchAllbarberBloc, FetchAllBarbersRequested;
import 'package:client_pannel/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/di.dart';
import 'service/cloudinary/cloudinary_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  CloudinaryConfig.initialize();

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
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fresh Fade',
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
    );
  }
}

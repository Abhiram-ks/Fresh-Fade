
import 'package:client_pannel/features/auth/presentations/state/bloc/splash_bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../widget/splash_widget/splash_body_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashBloc>()..add(SplashScreenRequest()),
      child: SafeArea(
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, splash) {
            splashStateHandle(context, splash);
          },

           child: Scaffold(
              backgroundColor: AppPalette.blackColor,
              body: SplashBodyWidget(),
            ),
         ),
        ),
    );
  }
}


void splashStateHandle(BuildContext context, SplashState state) {
  if (state is GoToLogin) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }else if (state is GoToHome){
   Navigator.pushReplacementNamed(context, AppRoutes.nav);
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/routes/routes.dart';
import '../../state/bloc/splash_bloc/splash_bloc.dart';

void splashStateHandle(BuildContext context, SplashState state) {
  if (state is GoToLogin) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }else if (state is GoToHome){
   Navigator.pushReplacementNamed(context, AppRoutes.nav);
  }
}

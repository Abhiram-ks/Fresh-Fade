
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_colors.dart';
import '../state/bloc/splash_bloc/splash_bloc.dart';
import '../widget/splash_widget/splash_body_widget.dart';
import '../widget/splash_widget/splash_state_handle.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      
      create: (context) => sl<SplashBloc>()..add(SplashScreenRequest()),
      child: ColoredBox(
        color: AppPalette.buttonColor,
        child: SafeArea(
          child: BlocListener<SplashBloc, SplashState>(
            listener: (context, splash) {
              splashStateHandle(context, splash);
            },
           child: 
            Scaffold(
              backgroundColor: AppPalette.buttonColor,
              body: SplashBodyWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

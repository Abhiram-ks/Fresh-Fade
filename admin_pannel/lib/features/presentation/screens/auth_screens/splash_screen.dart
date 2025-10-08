
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/images/images.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/bloc/splash_bloc/splash_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/splash_widget/splash_state_handle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashBloc>()..add(SplashScreenRequest()),
      child: ColoredBox(
        color: AppPalette.blueColor,
        child: SafeArea(
          child: BlocListener<SplashBloc, SplashState>(
            listener: (context, splash) {
              splashStateHandle(context, splash);
            },
            child: Scaffold(
              backgroundColor: AppPalette.blueColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.appLogo,
                            fit: BoxFit.contain,
                            height: 70,
                            width: 70,
                          ),
                          ConstantWidgets.hight10(context),
                          Text(
                            "Fresh Fade",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.whiteColor,
                            ),
                          ),
                          Text(
                            "Admin Portel",
                            style: GoogleFonts.poppins(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 12,
                        width: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: AppPalette.whiteColor,
                          color: AppPalette.greyColor,
                        ),
                      ),
                      ConstantWidgets.width40(context),
                      Text(
                        "Loading...",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  ConstantWidgets.hight30(context),
                  Text(
                    'Executing Smarter, Managing Better',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppPalette.whiteColor,
                    ),
                  ),
                  ConstantWidgets.hight30(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

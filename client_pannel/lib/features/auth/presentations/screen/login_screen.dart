import 'package:client_pannel/features/auth/presentations/state/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/di/di.dart';
import '../../../../core/images/app_images.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../state/cubit/progresser_cubit/progresser_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<AuthBloc>()),
      ],
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 245, 245, 245),
              resizeToAvoidBottomInset: false,
              body: LoginBodyWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginBodyWidget extends StatelessWidget {
  const LoginBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LoginScreenBody(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ),
    );
  }
}

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: screenWidth * 0.87,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor.withAlpha((0.89 * 255).round()),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppPalette.blackColor.withAlpha((0.1 * 255).round()),
              blurRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginDetailsWidget(screenWidth: screenWidth),
              LoginCredentialPart(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginDetailsWidget extends StatelessWidget {
  final double screenWidth;

  const LoginDetailsWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.appLogo, width: screenWidth * 0.15),
        Text(
          'Fresh Fade',
          textAlign: TextAlign.center,
          style: GoogleFonts.bellefair(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPalette.blackColor,
          ),
        ),
        Text(
          'A Smart Booking Application',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 9),
        ),
        ConstantWidgets.hight10(context),
        Text(
          "Save when you don't need it, and it’ll be there for you when you do…",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 10),
        ),
        ConstantWidgets.hight30(context),
        Text(
          "Welcome Back!",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ConstantWidgets.hight10(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_clock_outlined,
              size: 18,
              color: AppPalette.orengeColor,
            ),
            ConstantWidgets.width20(context),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Sign up with Google",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppPalette.orengeColor,
                ),
              ),
            ),
          ],
        ),
        ConstantWidgets.hight20(context),
      ],
    );
  }
}

class LoginCredentialPart extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const LoginCredentialPart({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Or"),
            ),
            Expanded(child: Divider()),
          ],
        ),

        ConstantWidgets.hight20(context),

        BlocListener<AuthBloc, AuthState>(
          listener: (context, googleState) {
            authStateHandle(context, googleState);
          },
          child:
        CustomGoogleField.googleSignInModule(
          context: context,
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          onTap: () {
             context.read<AuthBloc>().add(AuthSignInWithGoogleEvent());
          },
        ),

        ),
        ConstantWidgets.hight20(context),

        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "By creating or logging into an account you are agreeing with our ",
              style: const TextStyle(fontSize: 12, color: Colors.black54),

              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(color: AppPalette.orengeColor),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: AppPalette.orengeColor),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
      ],
    );
  }
}

void authStateHandle(BuildContext context, AuthState state) {
  final button = context.read<ProgresserCubit>();
  if (state is AuthSuccess) {
    button.stopLoading();
    Navigator.pushReplacementNamed(context, AppRoutes.nav);
  }else if (state is AuthFailure){
    button.stopLoading();
    CustomSnackBar.show(context, message: state.error,backgroundColor: AppPalette.redColor, textColor: AppPalette.whiteColor);
  } else if (state is AuthLoading) {
    button.startLoading();
  } else if (state is AuthInitial) {
    button.stopLoading();
  }
}




class CustomGoogleField {
  static Widget googleSignInModule({
    required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.062,
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withAlpha((0.87 * 255).round()),
        border: Border.all(color: AppPalette.hintColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppPalette.hintColor.withAlpha(100),
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.googleLogo,
                height: screenHeight * 0.06,
                fit: BoxFit.contain,
              ),
              ConstantWidgets.width20(context),
              BlocBuilder<ProgresserCubit, ProgresserState>(
                builder: (context, progresser) {
                  if (progresser is ButtonProgressStart) {
                    return Text(
                      'Please wait...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppPalette.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return Text(
                    'Sign Up with Google',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppPalette.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

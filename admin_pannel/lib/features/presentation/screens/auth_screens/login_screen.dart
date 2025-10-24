import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/images/images.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/data/datasource/auth_local_datasource.dart';
import 'package:admin_pannel/features/data/datasource/auth_remote_datasource.dart';
import 'package:admin_pannel/features/data/repo/auth_repo_impl.dart';
import 'package:admin_pannel/features/domain/usecase/login_admin_usecase.dart';
import 'package:admin_pannel/features/presentation/widgets/login_widget/login_credential.dart';
import 'package:admin_pannel/features/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => LoginBloc(loginAdminUseCase:LoginAdminUseCase(repository: AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSource()), localDb: AuthLocalDatasource()) )),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                resizeToAvoidBottomInset: false,
                body: LoginBodyWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ),
          );
        },
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
    bool isLargeScreen = screenWidth > 900;
    
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: isLargeScreen
            ? WebResponsiveLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )
            : LoginScreenBody(
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
          color: AppPalette.whiteColor.withAlpha((0.8 * 255).round()),
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
              LoginPolicyWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPolicyWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const LoginPolicyWidget({
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

        ConstantWidgets.hight10(context),
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
                  style: TextStyle(color: Colors.blue[700]),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
      ],
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
        Image.asset(AppImages.appLogo, width: 60, height: 60),
        Text(
          'Fresh Fade',
          textAlign: TextAlign.center,
          style: GoogleFonts.bellefair(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppPalette.blackColor,
          ),
        ),
        Text(
          'Executing Smarter, Managing Better',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 11, color: AppPalette.greyColor),
        ),
        ConstantWidgets.hight10(context),
        Text(
          "Welcome Back!",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ConstantWidgets.hight10(context),
        LoginCredential(),
        ConstantWidgets.hight10(context),
      ],
    );
  }
}

class WebResponsiveLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WebResponsiveLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppPalette.blueColor,
                  AppPalette.blueColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                        AppImages.appLogoWhite,
                        width: 120,
                        height: 120,
                      ),
                    
                    ConstantWidgets.hight30(context),
                    Text(
                      'Fresh Fade',
                      style: GoogleFonts.bellefair(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.whiteColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Executing Smarter, Managing Better',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppPalette.whiteColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'A Efficient administration, organizational management,\n and effective service promotion for streamlined shop operations and entry management.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppPalette.whiteColor.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    ConstantWidgets.hight30(context),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppPalette.whiteColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 50,
                            color: AppPalette.whiteColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Admin Panel',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: AppPalette.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Manage your business efficiently',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppPalette.whiteColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: AppPalette.whiteColor.withValues(alpha: 0.1),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: AppPalette.whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.blackColor.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ConstantWidgets.hight10(context),
                        Text(
                          "Sign in to continue to your dashboard",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppPalette.greyColor,
                          ),
                        ),
                        ConstantWidgets.hight30(context),
                        const LoginCredential(),
                          const SizedBox(height: 30),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Or",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppPalette.greyColor,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        ConstantWidgets.hight30(context),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By logging in, you agree to our ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(
                                    color: AppPalette.blueColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: AppPalette.blueColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

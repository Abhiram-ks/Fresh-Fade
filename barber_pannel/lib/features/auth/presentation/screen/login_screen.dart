import 'package:barber_pannel/features/auth/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/widget/login_widget/login_state_handle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/di/injection_contains.dart';
import '../../../../core/images/app_image.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/validation/validation_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<LoginBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;
          return ColoredBox(
            color: AppPalette.buttonColor,
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
                onRegisterTap: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                suffixText: "Don't have an account? ",
                prefixText: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPolicyWidget extends StatelessWidget {
  final Function() onRegisterTap;
  final double screenWidth;
  final double screenHeight;
  final String suffixText;
  final String prefixText;

  const LoginPolicyWidget({
    super.key,
    required this.onRegisterTap,
    required this.screenWidth,
    required this.screenHeight,
    required this.suffixText,
    required this.prefixText,
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
              text: suffixText,
              style: const TextStyle(fontSize: 12, color: Colors.black54),

              children: [
                TextSpan(
                  text: "Register",
                  style: TextStyle(color: AppPalette.buttonColor),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          onRegisterTap();
                        },
                ),
              ],
            ),
          ),
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
          'Innovate, Execute, Succeed',
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

class LoginCredential extends StatefulWidget {
  const LoginCredential({super.key});

  @override
  State<LoginCredential> createState() => _LoginCredentialState();
}

class _LoginCredentialState extends State<LoginCredential> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            hintText: 'Your answer',
            label: 'Email address *',
            validate: ValidatorHelper.validateEmailId,
            controller: _emailController,
          ),
          TextFormFieldWidget(
            hintText: '********',
            label: 'Password',
            validate: ValidatorHelper.validatePassword,
            controller: _passwordController,
            isPasswordField: true,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.lock_clock_outlined,
                size: 18,
                color: AppPalette.buttonColor,
              ),
              ConstantWidgets.width20(context),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Forgot password?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.buttonColor,
                  ),
                ),
              ),
            ],
          ),
          ConstantWidgets.hight20(context),
            BlocListener<LoginBloc, LoginState>(
          listener: (context, login) {
           handleLoginState(context, login);
          },
          child:
          CustomButton(
            text: 'Login',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(
                  LoginActionEvent(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ),
                );
              } else {
                CustomSnackBar.show(
                  context,
                  message: "All fields are required.",
                  textAlign: TextAlign.center,
                  backgroundColor: AppPalette.redColor,
                );
              }
            },
          ),
          ),
        ],
      ),
    );
  }
}

import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/widget/register_bloc/register_state_handle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/mediaquary_helper.dart';
import '../../../../core/validation/validation_helper.dart';

class RegisterCredentialsScreen extends StatelessWidget {
  RegisterCredentialsScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHight = MeidaQuaryHelper.height(context);
    double screenWidth = MeidaQuaryHelper.width(context);
    return BlocProvider(
      create: (context) => ProgresserCubit(),
      child: ColoredBox(
        color: AppPalette.buttonColor,
        child: SafeArea(
          child: Scaffold(
            appBar: const CustomAppBar(),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth > 600
                            ? screenWidth * .3
                            : screenWidth * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Us Today',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      Text(
                        'Create your account and unlock a world of possibilities.',
                      ),
                      ConstantWidgets.hight20(context),
                      CredentialsFormField(
                        screenWidth: screenWidth,
                        screenHight: screenHight,
                        formKey: _formKey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CredentialsFormField extends StatefulWidget {
  const CredentialsFormField({
    super.key,
    required this.screenWidth,
    required this.formKey,
    required this.screenHight,
  });

  final double screenWidth;
  final double screenHight;
  final GlobalKey<FormState> formKey;

  @override
  State<CredentialsFormField> createState() => _CredentialsFormFieldState();
}

class _CredentialsFormFieldState extends State<CredentialsFormField> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: "Email",
            hintText: "Enter Email id",
            prefixIcon: CupertinoIcons.mail_solid,
            controller: emailController,
            validate: ValidatorHelper.validateEmailId,
          ),
          TextFormFieldWidget(
            label: 'Create Password',
            hintText: 'Enter Password',
            isPasswordField: true,
            prefixIcon: CupertinoIcons.padlock_solid,
            controller: passwordController,
            validate: ValidatorHelper.validatePassword,
          ),
          TextFormFieldWidget(
            label: 'Confirm Password',
            hintText: 'Enter Password',
            prefixIcon: CupertinoIcons.padlock_solid,
            controller: confirmPasswordController,
            validate: (val) {
              return ValidatorHelper.validatePasswordMatch(
                passwordController.text,
                val,
              );
            },
            isPasswordField: true,
          ),
          ConstantWidgets.hight30(context),
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, register) {
              handleRegisterState(context, register);
            },
            child: CustomButton(
              text: 'Registger',
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  final registerBloc = context.read<RegisterBloc>();
                  registerBloc.add(
                    RegisterCredential(
                      email: emailController.text,
                      password: passwordController.text,
                      isVerified: false,
                      isBloc: false,
                    ),
                  );
                } else {
                  CustomSnackBar.show(
                    context,
                    message:'Please fill in all the required fields before proceeding..',
                    backgroundColor: AppPalette.redColor,
                    textAlign: TextAlign.center,
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

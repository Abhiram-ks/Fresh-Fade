import 'package:admin_pannel/core/common/custom_button.dart';
import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/common/custom_testfiled.dart';
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/core/validation/validation_helper.dart';
import 'package:admin_pannel/features/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/login_widget/login_state_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            hintText: 'Email address',
            label: 'Verified email *',
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
          ConstantWidgets.hight10(context),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, login) {
             loginStateHandle(context, login);
            },
            child: CustomButton(
              text: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(
                    LoginRequest(
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

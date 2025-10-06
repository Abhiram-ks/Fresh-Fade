import 'package:admin_pannel/core/common/custom_button.dart';
import 'package:admin_pannel/core/common/custom_testfiled.dart';
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/core/validation/validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Column(
      children: [
TextFormFieldWidget(hintText: 'Email address', label: 'Verified email *',validate: ValidatorHelper.validateEmailId, controller: _emailController,),
TextFormFieldWidget(hintText: '********', label: 'Password',validate: ValidatorHelper.validatePassword,controller: _passwordController, isPasswordField: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.lock_clock_outlined,
              size: 18,
              color: AppPalette.blueColor,
            ),
            ConstantWidgets.width20(context),
            GestureDetector(
              onTap: () {
              },
              child: Text(
                "Forgot password?",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppPalette.blueColor,
                ),
              ),
            ),
          ],
        ),
        ConstantWidgets.hight10(context),
        CustomButton(text: 'Login', onPressed: (){})
      ],
    );
  }
}
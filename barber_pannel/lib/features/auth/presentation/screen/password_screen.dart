import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/common/custom_testfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart' show AppPalette;
import 'package:barber_pannel/core/validation/validation_helper.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/mediaquary_helper.dart';
import '../../../../core/di/injection_contains.dart' show sl;
import '../state/bloc/password_bloc.dart/password_bloc.dart';

class PasswordScreen extends StatelessWidget {
  final bool isWhat;
  PasswordScreen({super.key, required this.isWhat});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHight = MeidaQuaryHelper.height(context);
    double screenWidth = MeidaQuaryHelper.width(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<PasswordBloc>()),
      ],
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: BouncingScrollPhysics(),
              child: PasswordBodyWIdget(
                screenWidth: screenWidth,
                screenHight: screenHight,
                formKey: _formKey,
                isWhat: isWhat,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordBodyWIdget extends StatefulWidget {
  const PasswordBodyWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.formKey,
    required this.isWhat,
  });

  final double screenWidth;
  final double screenHight;
  final bool isWhat;
  final GlobalKey<FormState> formKey;

  @override
  State<PasswordBodyWIdget> createState() => _PasswordBodyWIdgetState();
}

class _PasswordBodyWIdgetState extends State<PasswordBodyWIdget> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            widget.screenWidth > 600
                ? widget.screenWidth * .3
                : widget.screenWidth * 0.08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isWhat ? 'Forgot password?' : 'Change password?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          ConstantWidgets.hight10(context),
          Text(
            widget.isWhat
                ? "Enter your registered email address to receive a password reset link. Make sure to check your email for further instructions."
                : "Enter your registered email address to receive a password-changing link. Make sure to check your email for further instructions. After the process, your password will be updated.",
          ),
          ConstantWidgets.hight50(context),
          Form(
            key: widget.formKey,
            child: TextFormFieldWidget(
              label: 'Email',
              hintText: "Enter Email id",
              prefixIcon: CupertinoIcons.mail_solid,
              controller: emailController,
              validate: ValidatorHelper.validateEmailId,
            ),
          ),
          ConstantWidgets.hight30(context),
         BlocListener<PasswordBloc, PasswordState>(
              listener: (context, state) {
                handPasswordState(context, state);
              },
              child: Builder(
                builder: (context) {
                  final passwordBloc = context.read<PasswordBloc>();
                  return CustomButton(
                    text: "Varify",
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        passwordBloc.add(PasswordRequestedEvent(email: emailController.text.trim()));
                      } else {
                        CustomSnackBar.show(
                          context,
                          message: 'Fill in nessary data before proceeding.',
                          textAlign: TextAlign.center,
                          backgroundColor: AppPalette.redColor,
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}



  void handPasswordState(BuildContext context, PasswordState state){
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is PasswordLoadingState) {
    buttonCubit.startLoading();
  }
  if (state is PasswordSuccessState) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: 'Done! Open your inbox and follow the instructions to reset your password.',textAlign: TextAlign.center,backgroundColor: AppPalette.greenColor);
  } else if(state is PasswordErrorState){
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.message,textAlign: TextAlign.center,backgroundColor: AppPalette.redColor);
  }else if(state is PasswordAlertBoxState){
    buttonCubit.stopLoading();
    CustomCupertinoDialog.show(
      context: context, 
      title: "Password Mangement Alert", 
      message: "Are you sure you want to send a password reset email to ${state.email}?. Validate before proceeding.", 
      onTap: () {
        context.read<PasswordBloc>().add(PasswordConfirmationEvent());
      }, 
      firstButtonText: "Send Mail", 
      secondButtonText: "Cancel");
  }

}
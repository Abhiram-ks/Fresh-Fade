import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_locationfiled.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/constant/mediaquary_helper.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/custom_appbar.dart';
import '../../../../core/common/custom_phonetextfiled.dart';
import '../../../../core/common/custom_snackbar.dart';
import '../../../../core/common/custom_testfiled.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/validation/validation_helper.dart';
import '../state/bloc/register_bloc/register_bloc.dart';
import 'login_screen.dart';

class RegisterDetailsScreen extends StatelessWidget {
  RegisterDetailsScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MeidaQuaryHelper.height(context);
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? screenWidth * .3 : screenWidth * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register here',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      Text(
                        'Please enter your data to complete your account registration process.',
                      ),
                      ConstantWidgets.hight20(context),
                      DetilsFormField(
                        screenWidth: screenWidth,
                        screenHight: screenHeight,
                        formKey: _formKey,
                      ),
                      ConstantWidgets.hight10(context),
                      LoginPolicyWidget(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        onRegisterTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        suffixText: "Already have an account? ",
                        prefixText: "Login",
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

class DetilsFormField extends StatefulWidget {
  const DetilsFormField({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.formKey,
  });

  final double screenWidth;
  final double screenHight;
  final GlobalKey<FormState> formKey;

  @override
  State<DetilsFormField> createState() => _DetilsFormFieldState();
}

class _DetilsFormFieldState extends State<DetilsFormField> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ventureNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            label: 'Full Name',
            hintText: 'Authorized Person Name',
            prefixIcon: CupertinoIcons.person_fill,
            controller: nameController,
            validate: ValidatorHelper.validateText,
          ),
          TextFormFieldWidget(
            label: 'Venture name',
            hintText: 'Registered Venture Name',
            prefixIcon: Icons.add_business,
            controller: ventureNameController,
            validate: ValidatorHelper.validateText,
          ),
          TextfiledPhone(
            label: "Phone Number",
            hintText: "Enter your number",
            prefixIcon: Icons.phone_android,
            controller: phoneController,
            validator: ValidatorHelper.validatePhoneNumber,
          ),
          LocationTextformWidget.locationAccessField(
            label: 'Venture Address',
            hintText: 'Your Answer or Select from the map',
            prefixIcon: CupertinoIcons.location_solid,
            controller: addressController,
            validator: ValidatorHelper.validateLocation,
            prefixClr: AppPalette.blackColor,
            suffixClr: AppPalette.redColor,
            action: () {
              Navigator.pushNamed(context, AppRoutes.map, arguments: addressController);
            },
            suffixIcon: CupertinoIcons.map_pin_ellipse,
            context: context,
          ),
          ConstantWidgets.hight20(context),
      
          CustomButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                context.read<RegisterBloc>().add(RegisterPersonInfo(
                  name: nameController.text.trim(),
                  venturename: ventureNameController.text.trim(),
                  phonNumber: phoneController.text,
                  address: addressController.text,
                ));  
                Navigator.pushNamed(context, AppRoutes.registerCredential, arguments: addressController);
              } else {
                CustomSnackBar.show(
                  context,
                  message:'Please fill in all the required fields before proceeding.',
                  textAlign: TextAlign.center,
                  backgroundColor: AppPalette.redColor,
                );
              }
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }
}

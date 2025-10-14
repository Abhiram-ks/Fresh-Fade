import 'dart:io';

import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_locationfiled.dart';
import 'package:barber_pannel/core/common/custom_phonetextfiled.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/common/custom_testfiled.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/images/app_image.dart' show AppImages;
import 'package:barber_pannel/core/validation/validation_helper.dart'
    show ValidatorHelper;
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';

class ProfileScreen extends StatelessWidget {
  final bool isShow;
  ProfileScreen({super.key, required this.isShow});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ventureNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagePathClr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? selectImagePath;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(
          create: (context) => sl<FetchBarberBloc>()..add(FetchBarberRequest()),
        ),
        BlocProvider(create: (context) => sl<UpdateProfileBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(),
              body: BlocBuilder<FetchBarberBloc, FetchBarberState>(
                builder: (context, state) {
                  if (state is FetchBarberLoading) {
                   return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Center(
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: AppPalette.hintColor,
                            backgroundColor: AppPalette.buttonColor,
                            strokeWidth: 2,
                          ),
                        )
                      ),
                    );
                  }
                  if (state is FetchBarberLoaded) {
                    final barber = state.barber;
                    _imagePathClr.text = barber.image ?? '';
                    _nameController.text = barber.barberName;
                    _ventureNameController.text = barber.ventureName;
                    _phoneController.text = barber.phoneNumber;
                    _ageController.text = barber.age?.toString() ?? '';
                    _addressController.text = barber.address;
                    return SafeArea(
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth > 600
                                      ? screenWidth * .15
                                      : screenWidth * 0.057,
                            ),
                            child: Column(
                              children: [
                                BlocProvider(
                                  create: (context) => sl<ImagePickerBloc>(),
                                  child: BlocBuilder<
                                    ImagePickerBloc,
                                    ImagePickerState
                                  >(
                                    builder: (context, state) {
                                      if (state is ImagePickerLoaded) {
                                        selectImagePath = state.imagePath;
                                      }
                                      return ProfileEditDetailsWidget(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        isShow: isShow,
                                        barber: barber,
                                      );
                                    },
                                  ),
                                ),
                                ProfileEditDetailsFormsWidget(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                  isShow: isShow,
                                  barber: barber,
                                  formKey: _formKey,
                                  nameController: _nameController,
                                  addressController: _addressController,
                                  ageController: _ageController,
                                  phoneController: _phoneController,
                                  ventureNameController: _ventureNameController,
                                ),
                                ConstantWidgets.hight50(context),
                               
                                Text('Update At: ${barber.updatedAt?.day}/${barber.updatedAt?.month}/${barber.updatedAt?.year} At ${barber.updatedAt?.hour}:${barber.updatedAt?.minute}', textAlign: TextAlign.center,),
                                 Text(isShow ? '' : 'Below is your unique ID'),
                                Text(
                                  isShow ? '' : 'ID: //${barber.uid}',
                                  style: TextStyle(color: AppPalette.hintColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Image.asset(
                              AppImages.appLogo,
                              height: 50,
                              width: 50,
                            ),
                          ConstantWidgets.hight10(context),
                          Text(
                              "Due to Bad loading",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                           Text(
                              "Unable to connect to the server. Please contact the administrator for assistance.",
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  );
                  
                },
              ),
              floatingActionButton:
                  isShow
                      ? Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocListener<
                            UpdateProfileBloc,
                            UpdateProfileState
                          >(
                            listener: (context, update) {
                              handleProfileUpdateState(context, update);
                            },
                            child: CustomButton(
                              text: 'Save Changes',
                              onPressed: () {
                                selectImagePath ??= _imagePathClr.text;
                                context.read<UpdateProfileBloc>().add(
                                  UpdateProfileRequest(
                                    image: selectImagePath ?? '',
                                    barberName: _nameController.text,
                                    ventureName: _ventureNameController.text,
                                    phoneNumber: _phoneController.text,
                                    address: _addressController.text,
                                    year: int.parse(_ageController.text),
                                    hasNewImage: selectImagePath != null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}

void handleProfileUpdateState(BuildContext context, UpdateProfileState state) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is UpdateProfileAlertBox) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Warning! Data Overwrite',
      message:
          'This will overwrite existing data and cannot be undone. Are you sure you want to continue?',
      firstButtonText: "Allow",
      secondButtonText: 'Don’t Allow',
      onTap: () {
        context.read<UpdateProfileBloc>().add(ConfirmUpdateRequest());
      },
      firstButtonColor: AppPalette.buttonColor,
    );
  }
  if (state is UpdateProfileLoading) {
    buttonCubit.startLoading();
  } else if (state is UpdateProfileSuccess) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(
      context,
      message: 'Successfully Updated!',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.greenColor,
    );
  } else if (state is UpdateProfileError) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.message,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  }
}

class ProfileEditDetailsFormsWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isShow;
  final BarberEntity barber;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ventureNameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  const ProfileEditDetailsFormsWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isShow,
    required this.barber,
    required this.formKey,
    required this.nameController,
    required this.ventureNameController,
    required this.phoneController,
    required this.ageController,
    required this.addressController,
  });

  @override
  State<ProfileEditDetailsFormsWidget> createState() =>
      _ProfileEditDetailsFormsWidgetState();
}

class _ProfileEditDetailsFormsWidgetState
    extends State<ProfileEditDetailsFormsWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registration Info',
            style: TextStyle(color: AppPalette.hintColor),
          ),
          TextFormFieldWidget(
            label: 'Full Name',
            hintText: 'Authorized Person Name',
            prefixIcon: CupertinoIcons.person_fill,
            controller: widget.nameController,
            validate: ValidatorHelper.validateText,
            enabled: widget.isShow,
          ),
          TextFormFieldWidget(
            label: 'Venture name',
            hintText: 'Registered Venture Name',
            prefixIcon: Icons.add_business,
            controller: widget.ventureNameController,
            validate: ValidatorHelper.validateText,
            enabled: widget.isShow,
          ),
          TextfiledPhone(
            label: "Phone Number",
            hintText: "Enter your number",
            prefixIcon: Icons.phone_android,
            controller: widget.phoneController,
            validator: ValidatorHelper.validatePhoneNumber,
            enabled: widget.isShow,
            iconColor: AppPalette.buttonColor,
          ),
          Text('Venture Info', style: TextStyle(color: AppPalette.hintColor)),
          TextFormFieldWidget(
            label: 'Year Established',
            hintText: 'Your Answer',
            prefixIcon: CupertinoIcons.gift_fill,
            controller: widget.ageController,
            validate: ValidatorHelper.validateYear,
            enabled: widget.isShow,
          ),
          if (!widget.isShow)
            TextFormFieldWidget(
              label: 'Address',
              hintText: 'Your Answer',
              prefixIcon: CupertinoIcons.location_solid,
              controller: widget.addressController,
              minLines: 4,
              maxLines: 4,
              validate: ValidatorHelper.validateText,
              enabled: widget.isShow,
            ),
          if (widget.isShow)
            LocationTextformWidget.locationAccessField(
              label: 'Venture Address',
              hintText: 'Your Answer or Select from the map',
              prefixIcon: CupertinoIcons.location_solid,
              controller: widget.addressController,
              validator: ValidatorHelper.validateLocation,
              prefixClr: AppPalette.blackColor,
              suffixClr: AppPalette.redColor,
              action: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.map,
                  arguments: widget.addressController,
                );
              },
              suffixIcon: CupertinoIcons.map_pin_ellipse,
              context: context,
            ),
        ],
      ),
    );
  }
}

class ProfileEditDetailsWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isShow;
  final BarberEntity barber;
  const ProfileEditDetailsWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isShow,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isShow ? "Refine your profile" : 'Personal details',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        ConstantWidgets.hight10(context),
        Text(
          isShow
              ? "Update your personal details to keep your profile fresh and up to date. A better profile means a better experience!"
              : "The informations to verify your identity and to keep our community safe",
        ),
        ConstantWidgets.hight30(context),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: InkWell(
                onTap: () {
                  if (isShow) {
                    context.read<ImagePickerBloc>().add(PickImageAction());
                  }
                },
                child: Container(
                  color: AppPalette.greyColor,
                  width: 60,
                  height: 60,
                  child:
                      isShow
                          ? BlocBuilder<ImagePickerBloc, ImagePickerState>(
                            builder: (context, state) {
                              if (state is ImagePickerInitial) {
                                (barber.image != null &&
                                        barber.image!.startsWith('http'))
                                    ? imageshow(
                                      imageUrl: barber.image!,
                                      imageAsset: AppImages.appLogo,
                                    )
                                    : Image.asset(
                                      AppImages.appLogo,
                                      fit: BoxFit.cover,
                                    );
                              } else if (state is ImagePickerLoading) {
                                return Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: AppPalette.greyColor,
                                      backgroundColor: AppPalette.buttonColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              } else if (state is ImagePickerLoaded) {
                                return Image.file(
                                  File(state.imagePath),
                                  width: screenWidth,
                                  height: screenHeight,
                                  fit: BoxFit.cover,
                                );
                              } else if (state is ImagePickerError) {
                                return Center(
                                  child: Icon(
                                    CupertinoIcons.photo_fill_on_rectangle_fill,
                                    size: 35,
                                    color: AppPalette.buttonColor,
                                  ),
                                );
                              }
                              return (barber.image != null &&
                                      barber.image!.startsWith('http'))
                                  ? imageshow(
                                    imageUrl: barber.image!,
                                    imageAsset: AppImages.appLogo,
                                  )
                                  : Image.asset(
                                    AppImages.appLogo,
                                    fit: BoxFit.cover,
                                  );
                            },
                          )
                          : (barber.image != null &&
                              barber.image!.startsWith('http'))
                          ? imageshow(
                            imageUrl: barber.image!,
                            imageAsset: AppImages.appLogo,
                          )
                          : Image.asset(AppImages.appLogo, fit: BoxFit.cover),
                ),
              ),
            ),
            ConstantWidgets.width20(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileviewWidget(
                  screenWidth,
                  context,
                  Icons.verified,
                  barber.email,
                  textColor: AppPalette.greyColor,
                  AppPalette.blueColor,
                ),
              ],
            ),
          ],
        ),
        ConstantWidgets.hight20(context),
      ],
    );
  }
}

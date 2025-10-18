import 'dart:io';

import 'package:client_pannel/core/common/custom_button.dart';
import 'package:client_pannel/core/common/custom_loationtexedit.dart';
import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/features/app/domain/entity/user_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/common/custom_appbar.dart';
import '../../../../../../core/common/custom_cupertino_dialog.dart';
import '../../../../../../core/common/custom_phonnefiled.dart';
import '../../../../../../core/common/custom_testfiled.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/di/di.dart';
import '../../../../../../core/images/app_images.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../../core/validation/validator_helper.dart';
import '../../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../../state/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../settings_screen.dart';

class ProfileEditDetails extends StatefulWidget {
  final bool isShow;
  const ProfileEditDetails({super.key, required this.isShow});

  @override
  State<ProfileEditDetails> createState() => _ProfileEditDetailsState();
}

class _ProfileEditDetailsState extends State<ProfileEditDetails> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;
  late final TextEditingController _addressController;
  late final TextEditingController _imagePathClr;
  String? selectImagePath;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _ageController = TextEditingController();
    _addressController = TextEditingController();
    _imagePathClr = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _imagePathClr.dispose();
    super.dispose();
  }

  void _initializeControllers(UserEntity user) {
    if (!_isInitialized) {
      _imagePathClr.text = user.photoUrl;
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _ageController.text = user.age.toString();
      _addressController.text = user.address ?? '';
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FetchUserBloc>()..add(FetchUserStarted()),
        ),
        BlocProvider(create: (context) => sl<UpdateProfileBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return SafeArea(
            child: Scaffold(
              appBar: const CustomAppBar(),
              body: BlocBuilder<FetchUserBloc, FetchUserState>(
                builder: (context, state) {
                  if (state is FetchUserLoading) {
                    return Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.hintColor,
                          backgroundColor: AppPalette.orengeColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }
                  if (state is FetchUserLoaded) {
                    final user = state.user;
                    _initializeControllers(user);
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.077,
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
                                      isShow: widget.isShow,
                                      user: user,
                                    );
                                  },
                                ),
                              ),
                              ProfileEditDetailsFormsWidget(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                isShow: widget.isShow,
                                user: user,
                                formKey: _formKey,
                                nameController: _nameController,
                                addressController: _addressController,
                                ageController: _ageController,
                                phoneController: _phoneController,
                              ),
                              ConstantWidgets.hight20(context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Image.asset(
                                      AppImages.googleLogo,
                                      height: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text('Google-linked account'),
                                ],
                              ),
                              if (!widget.isShow)
                                Text(
                                  'Below is your unique ID',
                                  style: TextStyle(fontSize: 11),
                                ),
                              if (!widget.isShow)
                                Text(
                                  'ID: ${user.id}',
                                  style: TextStyle(fontSize: 9),
                                ),
                              Text(
                                'Created At : ${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year} At: ${user.createdAt.hour}:${user.createdAt.minute}:${user.createdAt.second}',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Updated At : ${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year} At: ${user.updatedAt.hour}:${user.updatedAt.minute}:${user.updatedAt.second}',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Unable to complete the request.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        Text('Please try again later.', style: TextStyle(fontSize:  12), textAlign: TextAlign.center,),
                        IconButton(
                          onPressed: () {
                            context.read<FetchUserBloc>().add(
                              FetchUserStarted(),
                            );
                          },
                          icon: Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                  );
                },
              ),
              floatingActionButton:
                  widget.isShow
                      ? SizedBox(
                        height: 45,
                        child: Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.09),
                          child: BlocListener<
                            UpdateProfileBloc,
                            UpdateProfileState
                          >(
                            listener: (context, state) {
                              handleProfileUpdateState(context, state);
                            },
                            child: CustomButton(text: 'Save Changes', onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                selectImagePath ??= _imagePathClr.text;
                                context.read<UpdateProfileBloc>().add(
                                  UpdateProfileRequestEvent(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    address: _addressController.text,
                                    age: int.tryParse(_ageController.text) ?? 0,
                                    photoUrl: selectImagePath ?? '',
                                  ),
                                );
                              } else {
                                CustomSnackBar.show(context, message: 'Please fill all the fields',backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
                              }
                            })
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






void handleProfileUpdateState (
  BuildContext context, UpdateProfileState state) {
     final buttonCubit = context.read<ProgresserCubit>();
    if (state is UpdateProfileAlertBox) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Warning! Data Overwrite',
      message: 'This will overwrite existing data and cannot be undone. Are you sure you want to continue?',
      firstButtonText: "Allow",
      secondButtonText: 'Don’t Allow',
      onTap: () {
        context.read<UpdateProfileBloc>().add(UpdateProfileConfirmEvent());
      },
      firstButtonColor: AppPalette.orengeColor,
    );
    }
    if(state is UpdateProfileLoading){
      buttonCubit.startLoading();
    }

    else if(state is UpdateProfileSuccess){
      buttonCubit.stopLoading();
      CustomSnackBar.show(context, message: 'Profile details have been updated.',backgroundColor: AppPalette.greenColor, textAlign: TextAlign.center);
    }else if(state is UpdateProfileError){
      CustomSnackBar.show(context, message: state.error,backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
      buttonCubit.stopLoading();
    }
  }














class ProfileEditDetailsFormsWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isShow;
  final UserEntity user;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  const ProfileEditDetailsFormsWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isShow,
    required this.user,
    required this.formKey,
    required this.nameController,
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
            style: TextStyle(color: AppPalette.greyColor),
          ),
          TextFormFieldWidget(
            label: 'Full Name',
            hintText: 'Authorized Person Name',
            prefixIcon: CupertinoIcons.person_fill,
            controller: widget.nameController,
            validate: ValidatorHelper.validateName,
            enabled: widget.isShow,
          ),
          TextfiledPhone(
            label: "Phone Number",
            hintText: "Enter your number",
            prefixIcon: Icons.phone_android,
            controller: widget.phoneController,
            validator: ValidatorHelper.validatePhoneNumber,

            enabled: widget.isShow,
          ),
          Text('Personal Info', style: TextStyle(color: AppPalette.greyColor)),
          LocationTextformWidget.locationAccessField(
            label: 'Venture Address',
            hintText: 'Your Answer or Select from the map',
            prefixIcon: CupertinoIcons.location_solid,
            controller: widget.addressController,
            validator: ValidatorHelper.validateLocation,
            enabled: widget.isShow,

            prefixClr: AppPalette.blackColor,
            suffixClr: AppPalette.redColor,
            action: () {
              Navigator.pushNamed(
                context,
                AppRoutes.map,
                arguments: widget.addressController,
              );
            },
            minLines: 2,
            maxLines: 2,
            suffixIcon: CupertinoIcons.map_pin_ellipse,
            context: context,
          ),
          TextFormFieldWidget(
            label: 'Age',
            hintText: 'Your Answer',
            prefixIcon: CupertinoIcons.gift_fill,
            controller: widget.ageController,
            validate: ValidatorHelper.validateAge,
            enabled: widget.isShow,
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
  final UserEntity user;
  const ProfileEditDetailsWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isShow,
    required this.user,
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
                  color: AppPalette.hintColor,
                  width: 60,
                  height: 60,
                  child:
                      isShow
                          ? BlocBuilder<ImagePickerBloc, ImagePickerState>(
                            builder: (context, state) {
                              if (state is ImagePickerInitial) {
                                user.photoUrl.startsWith('http')
                                    ? imageshow(
                                      imageUrl: user.photoUrl,
                                      imageAsset: AppImages.appLogo,
                                    )
                                    : Image.asset(
                                      AppImages.appLogo,
                                      fit: BoxFit.cover,
                                    );
                              } else if (state is ImagePickerLoading) {
                                return SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: AppPalette.orengeColor,
                                    backgroundColor: AppPalette.hintColor,
                                    strokeWidth: 2.5,
                                  ),
                                );
                              } else if (state is ImagePickerLoaded) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(state.imagePath),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (state is ImagePickerError) {
                                return Center(
                                  child: Icon(
                                    CupertinoIcons.photo_fill_on_rectangle_fill,
                                    size: 35,
                                    color: AppPalette.redColor,
                                  ),
                                );
                              }
                              return user.photoUrl.startsWith('http')
                                  ? imageshow(
                                    imageUrl: user.photoUrl,
                                    imageAsset: AppImages.appLogo,
                                  )
                                  : Image.asset(
                                    AppImages.appLogo,
                                    fit: BoxFit.cover,
                                  );
                            },
                          )
                          : (user.photoUrl.startsWith('http'))
                          ? imageshow(
                            imageUrl: user.photoUrl,
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
                  user.email,
                  textColor: AppPalette.blackColor,
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

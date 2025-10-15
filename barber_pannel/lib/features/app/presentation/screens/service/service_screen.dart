import 'dart:io';

import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/service/pdf/barber_pdf_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/common/custom_appbar2.dart';
import '../../state/bloc/upload_service_data_bloc.dart/upload_service_data_bloc.dart';
import '../../state/cubit/gender_option_cubit/gender_option_cubit.dart';
import '../../widget/service_widget/handle_state_service_upload.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ImagePickerBloc>()),
        BlocProvider(create: (context) => sl<UploadServiceDataBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => GenderOptionCubit(initialGender: getGenderOptionFromString(null))),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Scaffold(
            appBar: CustomAppBar2(title: 'Services Management', isTitle: true),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:
                    screenWidth > 600 ? screenWidth * .15 : screenWidth * .04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ratings & Reviews',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          profileviewWidget(
                            screenWidth,
                            context,
                            Icons.verified,
                            'by varified Customers',
                            textColor: AppPalette.greyColor,
                            AppPalette.blueColor,
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          showReviewDetisSheet(
                            context,
                            screenHeight,
                            screenHeight,
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                  ConstantWidgets.hight30(context),
                  Row(
                    children: [
                      Text(
                        '0.0 / 5',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      ConstantWidgets.width20(context),
                      RatingBarIndicator(
                        rating: 0.0,
                        itemBuilder:
                            (context, index) =>
                                Icon(Icons.star, color: AppPalette.blackColor),
                        itemCount: 5,
                        itemSize: 25.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  ConstantWidgets.hight10(context),
                  Text(
                    'Ratings and reiews are varified and are from people who use the same type of device that you use ⓘ',
                    style: TextStyle(fontSize: 12),
                  ),
                  Divider(),
                  ConstantWidgets.hight30(context),
                  ViewServiceDetailsPage(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ViewServiceDetailsPage extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const ViewServiceDetailsPage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  State<ViewServiceDetailsPage> createState() => _ViewServiceDetailsPageState();
}

class _ViewServiceDetailsPageState extends State<ViewServiceDetailsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<FetchBarberBloc, FetchBarberState>(
      builder: (context, state) {
        if (state is FetchBarberLoading) {
          return Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                color: AppPalette.hintColor,
                backgroundColor: AppPalette.buttonColor,
                strokeWidth: 2,
              ),
            )
          );
        } 
        else if (state is FetchBarberLoaded) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barber Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ConstantWidgets.hight10(context),
                Text(
                  "Please provide complete details of your barber shop. The generated BarberDocs will compile all submitted information, serving as an official reference for service management and business documentation.",
                  style: TextStyle(fontSize: 12),
                ),
                ConstantWidgets.hight20(context),
                UploadingServiceDatas(
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                  barber: state.barber,
                ),
                
              ConstantWidgets.hight10(context),
              CustomButton(
              onPressed: ()async {
                try {
                   final success = await BarberPdfService.generateBarberProfilePdf(
                  barber: state.barber,
                );
                
                if (context.mounted) {
                  if (!success) {
                    CustomSnackBar.show(
                      context,
                      message: 'Failed to generate PDF',
                      textAlign: TextAlign.center,
                      backgroundColor: AppPalette.redColor,
                    );
                  }
                }
                } catch (e) {
                  if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: e.toString(),
                    textAlign: TextAlign.center,
                    backgroundColor: AppPalette.redColor,
                  ); 
                  }
                }
              },
              text: 'Barber PDF',),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Unable to complete the request.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Please try again later.',textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
              IconButton(
                onPressed: () {
                  context.read<FetchBarberBloc>().add(FetchBarberRequest());
                },
                icon: Icon(CupertinoIcons.refresh,),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showReviewDetisSheet(
  BuildContext context,
  double screenHeight,
  double screenWidth,
) {
  showModalBottomSheet(
    backgroundColor: AppPalette.whiteColor,
    context: context,
    enableDrag: true,
    useSafeArea: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
    ),
    builder: (context) {
      return SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.appLogo, height: 50, width: 50),
                  ConstantWidgets.hight20(context),
                  Text(
                    "Unable to complete the request.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Unable to connect to the servcer. Please contact the administrator for assistance',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}




class UploadingServiceDatas extends StatefulWidget {
  const UploadingServiceDatas({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.barber,
  });

  final double screenWidth;
  final BarberEntity barber;
  final double screenHeight;

  @override
  State<UploadingServiceDatas> createState() => _UploadingServiceDatasState();
}

class _UploadingServiceDatasState extends State<UploadingServiceDatas> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gender = getGenderOptionFromString(widget.barber.gender);
      context.read<GenderOptionCubit>().selectGenderOption(gender);
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight30(context),
        InkWell(
          onTap: () {
            context.read<ImagePickerBloc>().add(PickImageAction());
          },
          child: DottedBorder(
            color: AppPalette.greyColor,
            strokeWidth: 1,
            dashPattern: [4, 4],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: SizedBox(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight * 0.23,
              child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
                builder: (context, state) {
                  if (state is ImagePickerInitial) {
                    if (widget.barber.detailImage != null &&
                        widget.barber.detailImage!.isNotEmpty &&
                        widget.barber.detailImage!.startsWith('http')) {
                      return SizedBox(
                        width: widget.screenWidth * 0.89,
                        height: widget.screenHeight * 0.22,
                        child: imageshow(
                          imageUrl: widget.barber.detailImage!,
                          imageAsset: AppImages.appLogo,
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: widget.screenWidth * 0.89,
                        height: widget.screenHeight * 0.22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.cloud_upload,
                              size: 35,
                              color: AppPalette.buttonColor,
                            ),
                            const Text('Upload an Image'),
                          ],
                        ),
                      );
                    }
                  } else if (state is ImagePickerLoading) {
                    return const CupertinoActivityIndicator(radius: 16.0);
                  } else if (state is ImagePickerLoaded) {
                    return buildImagePreview(state: state,screenWidth: widget.screenWidth*0.86,screenHeight: widget.screenHeight*41,radius: 12);
                  } else if (state is ImagePickerError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.photo,
                          size: 35,
                          color: AppPalette.redColor,
                        ),
                        Text(state.error)
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.cloud_upload,
                        size: 35,
                        color: AppPalette.buttonColor,
                      ),
                      Text('Upload an Images')
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
        const Text(
          "Select Gender",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ConstantWidgets.hight10(context),
        BlocBuilder<GenderOptionCubit, GenderOption>(
          builder: (context, selectedGender) {
            return Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              children: GenderOption.values.map((gender) {
                Color activeColor;
                String label;

                switch (gender) {
                  case GenderOption.male:
                    activeColor = AppPalette.buttonColor;
                    label = "Male";
                    break;
                  case GenderOption.female:
                    activeColor = AppPalette.buttonColor;
                    label = "Female";
                    break;
                  case GenderOption.unisex:
                    activeColor = AppPalette.buttonColor;
                    label = "Unisex";
                    break;
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<GenderOption>(
                      value: gender,
                      groupValue: selectedGender,
                      activeColor: activeColor,
                      onChanged: (value) {
                        if (value != null) {
                          context
                              .read<GenderOptionCubit>()
                              .selectGenderOption(value);
                        }
                      },
                    ),
                    Text(label),
                  ],
                );
              }).toList(),
            );
          },
        ),
        ConstantWidgets.hight20(context),
        BlocListener<UploadServiceDataBloc, UploadServiceDataState>(
          listener: (context, serviceState) {
           handleServiceWidgetState(context, serviceState);
          },
          child: CustomButton(
              onPressed: () {
                final imageState = context.read<ImagePickerBloc>().state;
                final genderState = context.read<GenderOptionCubit>().state;

                if (imageState is ImagePickerLoaded) {
                  context.read<UploadServiceDataBloc>().add(
                     UploadServiceDataRequest(
                          imagePath: imageState.imagePath,
                          gender: genderState));
                } else {
                  CustomSnackBar.show(context, message: 'Image Not Found!', textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
                }
              },
              text: 'Upload',),
        ),
      ],
    );
  }
}

GenderOption getGenderOptionFromString(String? gender) {
  switch (gender?.toLowerCase()) {
    case 'male':
      return GenderOption.male;
    case 'female':
      return GenderOption.female;
    case 'unisex':
      return GenderOption.unisex;
    default:
      return GenderOption.unisex;
  }
}


Widget buildImagePreview({required ImagePickerLoaded state,required double screenWidth,required double screenHeight,required int radius}) {
  final imageWidget = () {
   if (state.imagePath.startsWith('http')) {
      return Image.network(
        state.imagePath,
        width: screenWidth ,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else if (state.imagePath.isNotEmpty) {
      return Image.file(
        File(state.imagePath),
        width: screenWidth,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else {
      return const Text("No image selected");
    }
  }();

  return  ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
 
  );
}

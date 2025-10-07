import 'dart:ui' ;

import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../core/constant/constant.dart';
import '../../state/bloc/fetch_barber_banner_bloc/fetch_barber_banner_bloc.dart';
import '../../state/bloc/fetch_client_banner_bloc/fetch_client_banner_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/cubit/radio_button_cubit/radio_button_cubit.dart';

class BannerManagement extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const BannerManagement(
      {super.key, required this.screenHeight, required this.screenWidth});

  Future<void> _refreshContent(BuildContext context) async {
    context.read<FetchUserBannerBloc>().add(FetchUserBannerAction());
    context.read<FetchBannerBarberBloc>().add(FetchBarberBannerAction());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal:screenWidth > 600 ? screenWidth*.2 : screenWidth * 0.05,
        ),
        child: RefreshIndicator(
          onRefresh:()=>_refreshContent(context),
          displacement: 50.0,
          backgroundColor: AppPalette.blueColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: AppPalette.whiteColor,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ImagePickAndUploadWidget(screenWidth: screenWidth, screenHeight: screenHeight),
          ),
        ),
      );
    });
  }
}



class ImagePickAndUploadWidget extends StatelessWidget {
  const ImagePickAndUploadWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstantWidgets.hight20(context),
        ImagePickerWIdget(screenWidth: screenWidth, screenHeight: screenHeight),
        ConstantWidgets.hight20(context),
        BlocBuilder<RadioCubit, RadioState>(builder: (context, state) {
          String selectedOption = "Both";
          if (state is RadioSelected) {
            selectedOption = state.selectedOption;
          }
          return SizedBox(
            height: screenHeight * 0.3,
            width: double.infinity,
            child: Column(
              children: [
                RadioListTile<String>(
                    value: 'Client',
                    groupValue: selectedOption,
                    title: Text(
                      'Client',
                      style: TextStyle(color: AppPalette.blueColor),
                    ),
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    }),
                RadioListTile<String>(
                    value: 'Barber',
                    groupValue: selectedOption,
                    title: Text('Barber',
                        style: TextStyle(color: AppPalette.blueColor)),
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    }),
                RadioListTile<String>(
                    value: 'Both',
                    groupValue: selectedOption,
                    title: Text('Both',
                        style: TextStyle(color: AppPalette.blueColor)),
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    }),
              ],
            ),
          );
        }),
        BlocListener<ImageUploadBloc, ImageUploadState>(
          listener: (context, state) {
            handleImagUploadState(context, state);
          },
          child: ActionButton(
              screenWidth: screenWidth,
              onTap: () async {
                final pickImageState =context.read<PickImageBloc>().state;
                
    
                if (pickImageState is ImagePickerSuccess) {
                  final selectedOption = context.read<RadioCubit>().state;
                
                  if (selectedOption is RadioSelected) {
                   int  index = _getIndexFromOption(selectedOption.selectedOption);
                  context.read<ImageUploadBloc>().add(
                    ImageUploadRequested(imagePath: pickImageState.imagePath ?? '',imageBytes: pickImageState.imageBytes, index: index)
                  );
                  }
                } else if (pickImageState is PickImageInitial ||
                    pickImageState is ImagePickerError) {
                      CustomSnackBar.show(context, message: 'Process encountered an error because no image was found',);
                } else if (pickImageState is ImagePickerLoading) {
                  CustomSnackBar.show(context, message: 'Image Loading. Please wait while the process completes.', );
                }
              },
              label: 'Upload',
              screenHight: screenHeight),
        ),
        FetchBannerBuildWidget(screenHeight: screenHeight, screenWidth: screenWidth)
      ],
    );
  }
}






int _getIndexFromOption(String selectedOption){
  switch (selectedOption) {
    case 'Client':
      return 1;
    case 'Barber':
      return 2;
    case 'Both':
      return 3;
    default:
      return 0;
  }
}




class ImagePickerWIdget extends StatelessWidget {
  const ImagePickerWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: InkWell(
      onTap: () {
        context.read<PickImageBloc>().add(ImagePickerEvent());
      },
      child: DottedBorder(
        color: AppPalette.greyColor,
        strokeWidth: 1,
        dashPattern: [4, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.23,
          child: BlocBuilder<PickImageBloc, PickImageState>(
            builder: (context, state) {
              if (state is PickImageInitial) {
                return SizedBox(
                    width: screenWidth * 0.89,
                    height: screenHeight * 0.22,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.cloud_upload,
                          size: 35,
                          color: AppPalette.buttonClr,
                        ),
                        Text('Upload an Image')
                      ],
                    ));
              } else if (state is ImagePickerLoading) {
                return SpinKitCircle(
                  color: AppPalette.mainClr,
                );
              } else if (state is ImagePickerSuccess) {
                return buildImagePreview(state: state, screenWidth: screenWidth * 0.89, screenHeight: screenHeight * 0.2, radius: 12);
              } else if (state is ImagePickerError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.photo,
                      size: 35,
                      color: AppPalette.redClr,
                    ),
                    Text(state.errorMessage)
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
                    color: AppPalette.buttonClr,
                  ),
                  Text('Upload an Image')
                ],
              );
            },
          ),
        ),
      ),
    ));
  }
}


void handleImagUploadState(BuildContext context, ImageUploadState state) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is ImageUploadError) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: 'Image Upload Failed Due to the following error: ${state.error}. Please try again.', backgroundColor: AppPalette.redColor);
  }else if(state is ImageUploadSuccess){
   buttonCubit.stopLoading();
   context.read<PickImageBloc>().add(ClearImageAction());
    CustomSnackBar.show(context, message: 'Image Upload Completed', backgroundColor: AppPalette.greenColor);
  } else if (state is ImageUploadLoading) {
    buttonCubit.startLoading();
  }
}
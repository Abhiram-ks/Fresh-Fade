import 'dart:developer';

import 'package:admin_pannel/core/common/custom_button.dart';
import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/di/service_locator.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/custom_dialogbox.dart';
import '../../../../core/constant/constant.dart';
import '../../state/bloc/fetch_barber_banner_bloc/fetch_barber_banner_bloc.dart';
import '../../state/bloc/fetch_client_banner_bloc/fetch_client_banner_bloc.dart';
import '../../state/bloc/image_delete_bloc/image_delete_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/bloc/image_upload_bloc/image_upload_bloc.dart';
import '../../state/cubit/radio_button_cubit/radio_button_cubit.dart';
import '../../widgets/promotions_widget/image_picker_widget.dart';

class PromotionScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const PromotionScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchUserBannerBloc>(
          create:
              (context) =>
                  sl<FetchUserBannerBloc>()..add(FetchUserBannerAction()),
        ),
        BlocProvider<FetchBannerBarberBloc>(
          create:
              (context) =>
                  sl<FetchBannerBarberBloc>()..add(FetchBarberBannerAction()),
        ),
        BlocProvider<ImageUploadBloc>(
          create: (context) => sl<ImageUploadBloc>(),
        ),
        BlocProvider<ImageDeletionBloc>(
          create: (context) => sl<ImageDeletionBloc>(),
        ),
        BlocProvider<PickImageBloc>(create: (context) => sl<PickImageBloc>()),
        BlocProvider<ProgresserCubit>(
          create: (context) => sl<ProgresserCubit>(),
        ),
        BlocProvider<RadioCubit>(create: (context) => sl<RadioCubit>()),
      ],
      child: BannerManagement(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}

class BannerManagement extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const BannerManagement({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  Future<void> _refreshContent(BuildContext context) async {
    context.read<FetchUserBannerBloc>().add(FetchUserBannerAction());
    context.read<FetchBannerBarberBloc>().add(FetchBarberBannerAction());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                screenWidth > 600 ? screenWidth * .2 : screenWidth * 0.05,
          ),
          child: RefreshIndicator(
            onRefresh: () => _refreshContent(context),
            displacement: 50.0,
            backgroundColor: AppPalette.blueColor,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: AppPalette.whiteColor,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ImagePickAndUploadWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          ),
        );
      },
    );
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
        BlocBuilder<RadioCubit, RadioState>(
          builder: (context, state) {
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
                      'Client Promotions',
                      style: TextStyle(color: AppPalette.blueColor),
                    ),
                    activeColor: AppPalette.blueColor,
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Barber',
                    groupValue: selectedOption,
                    activeColor: AppPalette.blueColor,
                    title: Text(
                      'Barber Promotions',
                      style: TextStyle(color: AppPalette.blueColor),
                    ),
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Both',
                    groupValue: selectedOption,
                    activeColor: AppPalette.blueColor,
                    title: Text(
                      'Both',
                      style: TextStyle(color: AppPalette.blueColor),
                    ),
                    onChanged: (value) {
                      context.read<RadioCubit>().selectOption(value!);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        BlocListener<ImageUploadBloc, ImageUploadState>(
          listener: (context, state) {
            handleImagUploadState(context, state);
          },
          child: CustomButton(
            onPressed: () async {
              final pickImageState = context.read<PickImageBloc>().state;

              if (pickImageState is ImagePickerSuccess) {
                final selectedOption = context.read<RadioCubit>().state;

                if (selectedOption is RadioSelected) {
                  int index = _getIndexFromOption(
                    selectedOption.selectedOption,
                  );
                  log(
                    'index: $index, imagePath: ${pickImageState.imagePath}, imageBytes: ${pickImageState.imageBytes} selectedOption: ${selectedOption.selectedOption} ',
                  );
                  context.read<ImageUploadBloc>().add(
                    ImageUploadRequested(
                      imagePath: pickImageState.imagePath ?? '',
                      imageBytes: pickImageState.imageBytes,
                      index: index,
                    ),
                  );
                }
              } else if (pickImageState is PickImageInitial ||
                  pickImageState is ImagePickerError) {
                CustomSnackBar.show(
                  context,
                  message:
                      'Process encountered an error because no image was found',
                  textAlign: TextAlign.center,
                );
              } else if (pickImageState is ImagePickerLoading) {
                CustomSnackBar.show(
                  context,
                  message:
                      'Image Loading. Please wait while the process completes.',
                  textAlign: TextAlign.center,
                );
              }
            },
            text: 'Upload',
          ),
        ),
        FetchBannerBuildWidget(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
        ),
      ],
    );
  }
}

class FetchBannerBuildWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const FetchBannerBuildWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageDeletionBloc, ImageDeletionState>(
      listener: (context, state) {
        if (state is ShowAlertConfirmation) {
          CustomCupertinoDialog.show(
            context: context,
            title: 'Banner Deletion Confirmation',
            message:
                "Confirm deletion? This action is irreversible, and the Banner will be permanently removed from the database.",
            firstButtonText: 'Allow',
            onTap: () {
              context.read<ImageDeletionBloc>().add(ImageDeletionConfirm());
              // Navigator.pop(context);
            },
            secondButtonText: "Don't Allow",
            firstButtonColor: AppPalette.redColor,
            secondButtonColor: AppPalette.blackColor,
          );
        }
      },
      child: Column(
        children: [
          Text(
            "Delete on long press of the image.",
            style: TextStyle(color: AppPalette.greyColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          BlocBuilder<FetchUserBannerBloc, FetchUserBannerState>(
            builder: (context, state) {
              if (state is FetchUserBannerLoading) {
                 return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight30(context),
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.blueColor,
                          backgroundColor: AppPalette.hintColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      Text('Just a moment...'),
                    ],
                  ),
                );
              } else if (state is UserBannerLoadedState) {
                if (state.userBanner.imageUrls.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidgets.hight30(context),
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 50,
                          color: AppPalette.blackColor,
                        ),
                       Text(
                          "Oops! There's nothing here yet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'No services added yet time to take action!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                } else {
                  return BannerBuilderWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    title: "User Promotions",
                    imageWidgets: state.userBanner.imageUrls,
                    number: 1,
                    onDoubleTap: (url, number, imageIndex) {
                      context.read<ImageDeletionBloc>().add(
                        ImageDeletionAction(
                          imageUrl: url,
                          index: 1,
                          imageIndex: imageIndex,
                        ),
                      );
                    },
                  );
                }
              }
               return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidgets.hight30(context),
                    Icon(
                      Icons.cloud_off_outlined,
                      color: AppPalette.blackColor,
                      size: 50,
                    ),
                    Text(
                      "Oop's Unable to complete the request. Please try again later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<FetchBannerBarberBloc>().add(
                          FetchBarberBannerAction(),
                        );
                      },
                      icon: Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              );
            },
          ),
          ConstantWidgets.hight10(context),
          BlocBuilder<FetchBannerBarberBloc, FetchBannerBarberState>(
            builder: (context, state) {
              if (state is FetchBarberBannerLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight30(context),
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.blueColor,
                          backgroundColor: AppPalette.hintColor,
                          strokeWidth: 2.5,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      Text('Just a moment...'),
                    ],
                  ),
                );
              } else if (state is BarberBannerLoadedState) {
                if (state.barberBanner.imageUrls.isEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidgets.hight30(context),
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 50,
                          color: AppPalette.blackColor,
                        ),
                        Text(
                          "Oops! There's nothing here yet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'No services added yet time to take action!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                } else {
                  return BannerBuilderWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    title: "Barber Promotions",
                    number: 2,
                    onDoubleTap: (url, number, imageIndex) {
                      context.read<ImageDeletionBloc>().add(
                        ImageDeletionAction(
                          imageUrl: url,
                          index: 2,
                          imageIndex: imageIndex,
                        ),
                      );
                    },
                    imageWidgets: state.barberBanner.imageUrls,
                  );
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidgets.hight30(context),
                    Icon(
                      Icons.cloud_off_outlined,
                      color: AppPalette.blackColor,
                      size: 50,
                    ),
                    Text(
                      "Oop's Unable to complete the request. Please try again later.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<FetchBannerBarberBloc>().add(
                          FetchBarberBannerAction(),
                        );
                      },
                      icon: Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              );
            },
          ),
          ConstantWidgets.hight30(context),
        ],
      ),
    );
  }
}

class BannerBuilderWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String title;
  final int number;
  final List<String> imageWidgets;
  final Function(String url, int index, int imageIndex) onDoubleTap;

  const BannerBuilderWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.title,
    required this.number,
    required this.imageWidgets,
    required this.onDoubleTap,
  });

  @override
  State<BannerBuilderWidget> createState() => _BannerBuilderWidgetState();
}

class _BannerBuilderWidgetState extends State<BannerBuilderWidget> {
  final ScrollController _scrollController = ScrollController();

  void scrollToPrevious() {
    _scrollController.animateTo(
      _scrollController.offset - widget.screenWidth * 0.87,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollToNext() {
    _scrollController.animateTo(
      _scrollController.offset + widget.screenWidth * 0.87,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight20(context),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppPalette.blueColor),
        ),
        SizedBox(
          height: widget.screenHeight * 0.25,
          width: widget.screenWidth,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imageWidgets.length,
                  itemBuilder: (context, imageIndex) {
                    final imageUrl = widget.imageWidgets[imageIndex];
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onLongPress: () {
                        widget.onDoubleTap(imageUrl, widget.number, imageIndex);
                      },
                      child: Container(
                        height: widget.screenHeight * 0.25,
                        width: widget.screenWidth * 0.87,
                        decoration: BoxDecoration(
                          color: AppPalette.trasprentColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppPalette.blueColor,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.photo,
                                    color: AppPalette.greyColor,
                                    size: 50,
                                  ),
                                  Text('Oops! Image load failed...'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Left arrow
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 28),
                  color: Colors.black54,
                  onPressed: scrollToPrevious,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 28),
                  color: Colors.black54,
                  onPressed: scrollToNext,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

int _getIndexFromOption(String selectedOption) {
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

void handleImagUploadState(BuildContext context, ImageUploadState state) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is ImageUploadError) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(
      context,
      message:
          'Image Upload Failed Due to the following error: ${state.error}. Please try again.',
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  } else if (state is ImageUploadSuccess) {
    buttonCubit.stopLoading();
    context.read<PickImageBloc>().add(ClearImageAction());
    CustomSnackBar.show(
      context,
      message: 'Image Upload Completed',
      backgroundColor: AppPalette.greenColor,
      textAlign: TextAlign.center,
    );
  } else if (state is ImageUploadLoading) {
    buttonCubit.startLoading();
  }
}

import 'dart:developer';

import 'package:admin_pannel/core/common/custom_button.dart';
import 'package:admin_pannel/core/common/custom_snackbar.dart';
import 'package:admin_pannel/core/di/di.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/custom_dialogbox.dart';
import '../../../../core/constant/constant.dart';
import '../../state/bloc/fetch_barber_banner_bloc/fetch_barber_banner_bloc.dart';
import '../../state/bloc/fetch_client_banner_bloc/fetch_client_banner_bloc.dart';
import '../../state/bloc/image_delete_bloc/image_delete_bloc.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../state/bloc/image_upload_bloc/image_upload_bloc.dart';
import '../../state/cubit/radio_button_cubit/radio_button_cubit.dart';
import '../../widgets/promotions_widget/image_picker_widget.dart';
import 'service.dart';

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
        // Check if it's a large screen (web/tablet)
        bool isLargeScreen = screenWidth > 900;
        
        return isLargeScreen
            ? WebResponsivePromotionLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onRefresh: () => _refreshContent(context),
              )
            : MobilePromotionLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onRefresh: () => _refreshContent(context),
              );
      },
    );
  }
}

// Mobile Layout (unchanged)
class MobilePromotionLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Future<void> Function() onRefresh;

  const MobilePromotionLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 600 ? screenWidth * .2 : screenWidth * 0.05,
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
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
  }
}

// Web Responsive Layout for Large Screens
class WebResponsivePromotionLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Future<void> Function() onRefresh;

  const WebResponsivePromotionLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1200,
              minWidth: 800,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar - Promotion Management Info
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppPalette.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.blackColor.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppPalette.blueColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CupertinoIcons.photo_on_rectangle,
                                color: AppPalette.blueColor,
                                size: 24,
                              ),
                            ),
                            ConstantWidgets.width20(context),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Banner Management',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.blackColor,
                                    ),
                                  ),
                                  Text(
                                    'Manage promotional banners',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppPalette.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ConstantWidgets.hight30(context),
                        
                        // Info Cards
                        buildInfoCard(
                          icon: CupertinoIcons.cloud_upload,
                          title: 'Upload Banners',
                          description: 'Add promotional images for clients and barbers',
                          color: AppPalette.greenColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        buildInfoCard(
                          icon: CupertinoIcons.photo,
                          title: 'View Banners',
                          description: 'See all uploaded promotional banners',
                          color: AppPalette.blueColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        buildInfoCard(
                          icon: CupertinoIcons.delete,
                          title: 'Delete Banners',
                          description: 'Remove outdated promotional content',
                          color: AppPalette.redColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPalette.blueColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppPalette.blueColor.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.lightbulb,
                                    color: AppPalette.blueColor,
                                    size: 20,
                                  ),
                                  Text(
                                    'Pro Tip',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppPalette.blueColor,
                                    ),
                                  ),
                                ],
                              ),
                              ConstantWidgets.hight10(context),
                              Text(
                                'Use high-quality images for better engagement. Recommended size: 1200x600px for optimal display.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppPalette.greyColor,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Right Side - Banner Upload and Management
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      displacement: 50.0,
                      backgroundColor: AppPalette.blueColor,
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      color: AppPalette.whiteColor,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: AppPalette.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.blackColor.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ImagePickAndUploadWidget(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
    // Calculate responsive dimensions
    bool isLargeScreen = widget.screenWidth > 900;
    double bannerHeight = isLargeScreen ? 180 : widget.screenHeight * 0.25;
    double bannerWidth = isLargeScreen ? 300 : widget.screenWidth * 0.87;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight20(context),
        Row(
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: AppPalette.blueColor,
              ),
            ),
            if (isLargeScreen) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPalette.blueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.imageWidgets.length} banners',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppPalette.blueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        ConstantWidgets.hight10(context),
        SizedBox(
          height: bannerHeight,
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
                    return _buildBannerItem(
                      imageUrl: imageUrl,
                      imageIndex: imageIndex,
                      bannerHeight: bannerHeight,
                      bannerWidth: bannerWidth,
                      isLargeScreen: isLargeScreen,
                    );
                  },
                ),
              ),
              // Navigation arrows
              if (widget.imageWidgets.length > 1) ...[
                // Left arrow
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppPalette.whiteColor.withValues(alpha: 0.8),
                          AppPalette.whiteColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: isLargeScreen ? 32 : 28,
                        color: AppPalette.blueColor,
                      ),
                      onPressed: scrollToPrevious,
                    ),
                  ),
                ),
                // Right arrow
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          AppPalette.whiteColor.withValues(alpha: 0.8),
                          AppPalette.whiteColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: isLargeScreen ? 32 : 28,
                        color: AppPalette.blueColor,
                      ),
                      onPressed: scrollToNext,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem({
    required String imageUrl,
    required int imageIndex,
    required double bannerHeight,
    required double bannerWidth,
    required bool isLargeScreen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onLongPress: () {
        widget.onDoubleTap(imageUrl, widget.number, imageIndex);
      },
      child: Container(
        height: bannerHeight,
        width: bannerWidth,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isLargeScreen ? [
            BoxShadow(
              color: AppPalette.blackColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: bannerWidth,
                height: bannerHeight,
                fit: isLargeScreen ? BoxFit.contain : BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildBannerLoading(loadingProgress, isLargeScreen);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildBannerError(isLargeScreen);
                },
              ),
            ),
            // Overlay for delete hint
            if (isLargeScreen)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppPalette.redColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Long press to delete',
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: AppPalette.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerLoading(ImageChunkEvent loadingProgress, bool isLargeScreen) {
    return Container(
      color: AppPalette.whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppPalette.blueColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 12 : 10,
                color: AppPalette.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerError(bool isLargeScreen) {
    return Container(
      color: AppPalette.whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.photo,
              color: AppPalette.greyColor,
              size: isLargeScreen ? 40 : 30,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load',
              style: GoogleFonts.poppins(
                fontSize: isLargeScreen ? 12 : 10,
                color: AppPalette.greyColor,
              ),
            ),
          ],
        ),
      ),
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

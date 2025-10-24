
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/app_colors.dart';
import '../../state/bloc/image_picker_bloc/image_picker_bloc.dart';

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
    // Calculate responsive dimensions
    bool isLargeScreen = screenWidth > 900;
    double containerWidth = isLargeScreen ? 400 : screenWidth * 0.9;
    double containerHeight = isLargeScreen ? 200 : screenHeight * 0.23;
    
    return Center(
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
          child: Container(
            width: containerWidth,
            height: containerHeight,
            constraints: isLargeScreen 
                ? BoxConstraints(
                    maxWidth: 500,
                    minWidth: 350,
                    maxHeight: 250,
                    minHeight: 150,
                  )
                : null,
            child: BlocBuilder<PickImageBloc, PickImageState>(
              builder: (context, state) {
                if (state is PickImageInitial) {
                  return _buildUploadPlaceholder(containerWidth, containerHeight);
                } else if (state is ImagePickerLoading) {
                  return _buildLoadingIndicator();
                } else if (state is ImagePickerSuccess) {
                  return buildImagePreview(
                    state: state, 
                    screenWidth: containerWidth * 0.95, 
                    screenHeight: containerHeight * 0.9, 
                    radius: 12,
                    isLargeScreen: isLargeScreen,
                  );
                } else if (state is ImagePickerError) {
                  return _buildErrorState(state.errorMessage);
                }
                return _buildUploadPlaceholder(containerWidth, containerHeight);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.cloud_upload,
            size: screenWidth > 900 ? 50 : 35,
            color: AppPalette.blueColor,
          ),
          Text(
            'Upload an Image',
            style: GoogleFonts.poppins(
              fontSize: screenWidth > 900 ? 16 : 14,
              fontWeight: FontWeight.w500,
              color: AppPalette.blackColor,
            ),
          ),
          Text(
            'Tap to select from gallery',
            style: GoogleFonts.poppins(
              fontSize: screenWidth > 900 ? 12 : 10,
              color: AppPalette.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenWidth > 900 ? 25 : 15,
            width: screenWidth > 900 ? 25 : 15,
            child: CircularProgressIndicator(
              color: AppPalette.blueColor,
              backgroundColor: AppPalette.hintColor,
              strokeWidth: 2.5,
            ),
          ),
        //  ConstantWidgets.hight10(context),
          Text(
            'Processing...',
            style: GoogleFonts.poppins(
              fontSize: screenWidth > 900 ? 14 : 12,
              color: AppPalette.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.photo,
            size: screenWidth > 900 ? 50 : 35,
            color: AppPalette.redColor,
          ),
          Text(
            'Upload Failed',
            style: GoogleFonts.poppins(
              fontSize: screenWidth > 900 ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: AppPalette.redColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth > 900 ? 12 : 10,
                color: AppPalette.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




Widget buildImagePreview({
  required ImagePickerSuccess state,
  required double screenWidth,
  required double screenHeight,
  required int radius,
  bool isLargeScreen = false,
}) {
  final imageWidget = () {
    if (kIsWeb && state.imageBytes != null) {
      return Image.memory(
        state.imageBytes!,
        width: screenWidth,
        height: screenHeight,
        fit: isLargeScreen ? BoxFit.contain : BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    } else if (state.imagePath != null && state.imagePath!.startsWith('http')) {
      return Image.network(
        state.imagePath!,
        width: screenWidth,
        height: screenHeight,
        fit: isLargeScreen ? BoxFit.contain : BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoading(loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    } else if (state.imagePath != null && state.imagePath!.isNotEmpty) {
      return Image.file(
        File(state.imagePath!),
        width: screenWidth,
        height: screenHeight,
        fit: isLargeScreen ? BoxFit.contain : BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    } else {
      return _buildImageError();
    }
  }();

  return Container(
    width: screenWidth,
    height: screenHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius.toDouble()),
      boxShadow: isLargeScreen ? [
        BoxShadow(
          color: AppPalette.blackColor.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ] : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius.toDouble()),
      child: Stack(
        children: [
          imageWidget,
          // Overlay for better visibility
          if (isLargeScreen)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPalette.blackColor.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Preview',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
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

Widget _buildImageLoading(ImageChunkEvent loadingProgress) {
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
            'Loading image...',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppPalette.greyColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildImageError() {
  return Container(
    color: AppPalette.whiteColor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.photo,
            color: AppPalette.greyColor,
            size: 40,
          ),
          Text(
            'Image not available',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppPalette.greyColor,
            ),
          ),
        ],
      ),
    ),
  );
}

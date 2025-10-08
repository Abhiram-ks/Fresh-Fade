
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';

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
                          color: AppPalette.blueColor,
                        ),
                        Text('Upload an Image')
                      ],
                    ));
              } else if (state is ImagePickerLoading) {
              return  Center(
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    color: AppPalette.blueColor,
                    backgroundColor: AppPalette.hintColor,
                    strokeWidth: 2.5,
                  ),
                ),
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
                      color: AppPalette.redColor,
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
                    color: AppPalette.blueColor,
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




Widget buildImagePreview({required ImagePickerSuccess state,required double screenWidth,required double screenHeight,required int radius}) {
  final imageWidget = () {
    if (kIsWeb && state.imageBytes != null) {
      return Image.memory(
        state.imageBytes!,
        width: screenWidth,
        height: screenHeight,
        fit: screenWidth > 600 ? BoxFit.contain : BoxFit.cover,
      );
    } else if (state.imagePath != null && state.imagePath!.startsWith('http')) {
      return Image.network(
        state.imagePath!,
        width: screenWidth ,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else if (state.imagePath != null && state.imagePath!.isNotEmpty) {
      return Image.file(
        File(state.imagePath!),
        width: screenWidth,
        height: screenHeight,
        fit: BoxFit.cover,
      );
    } else {
      return const Text("No image selected");
    }
  }();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    );
}

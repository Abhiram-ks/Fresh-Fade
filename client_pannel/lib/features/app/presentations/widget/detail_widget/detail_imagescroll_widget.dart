
import 'package:client_pannel/features/app/presentations/state/cubit/detailed_imageslider_cubit/detailed_imageslider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../screen/settings/settings_screen.dart';
import 'deatil_iconfileed_widget.dart';

class ImageScolingWidget extends StatelessWidget {
  const ImageScolingWidget({
    super.key,
    required this.imageList,
    required this.screenHeight,
    required this.screenWidth,
    required this.show,
  });

  final List<String> imageList;
  final double screenHeight;
  final double screenWidth;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailedImagesliderCubit(imageList: imageList),
      child: Builder(
        builder: (context) {
          final cubit = context.read<DetailedImagesliderCubit>();
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: SizedBox(
              height: screenHeight * 0.29,
              width: screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: cubit.pageController,
                    itemCount: imageList.length,
                    onPageChanged: cubit.updatePage,
                    itemBuilder: (context, index) {
                      return (imageList[index].startsWith('http'))
                          ? imageshow(
                              imageUrl: imageList[index],
                              imageAsset: imageList[index])
                          : Image.asset(
                              AppImages.barberEmpty,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            );
                    },
                  ),
                  
                      if(show)
                  Positioned(
                      top: 40,
                      left: 20,
                      child: iconsFilledDetail(
                        icon: Icons.arrow_back,
                        forgroudClr: AppPalette.whiteColor,
                        context: context,
                        borderRadius: 100,
                        padding: 10,
                        fillColor:
                            AppPalette.blackColor.withAlpha((0.45 * 255).toInt()),
                        onTap: () => Navigator.pop(context),
                      )),
                   Positioned(
                    bottom: 8,
                    child: BlocBuilder<DetailedImagesliderCubit, int>(
                      builder: (context, state) {
                        return SmoothPageIndicator(
                          controller: cubit.pageController,
                          count: imageList.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: AppPalette.whiteColor,
                            dotColor: AppPalette.orengeColor,
                          ),
                        );
                      },
                    ),
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

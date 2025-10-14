
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/image_slider_cubit/image_slider_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/constant/constant.dart';

class ImageSlider extends StatelessWidget {
  final BannerEntity banners;

  const ImageSlider({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ImageSliderCubit(imageList: banners.bannerImage.length),
      child: BlocBuilder<ImageSliderCubit, int>(
        builder: (context, state) {
          final cubit = context.read<ImageSliderCubit>();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantWidgets.hight20(context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                width: double.infinity,
                child: PageView.builder(
                  controller: cubit.pageController,
                  onPageChanged: cubit.updatePage,
                  itemCount: banners.bannerImage.length,
                  itemBuilder: (context, index) {
                    final banner = banners.bannerImage[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          banner,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppPalette.buttonColor,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_search,
                                      size: 40,
                                      color: AppPalette.greyColor,
                                    ),
                                    ConstantWidgets.hight10(context),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        color: AppPalette.greyColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Having trouble loading the image.',
                                      style: TextStyle(
                                        color: AppPalette.greyColor,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              ConstantWidgets.hight20(context),
              SmoothPageIndicator(
                controller: cubit.pageController,
                count: banners.bannerImage.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 16,
                  activeDotColor: AppPalette.blueColor,
                  dotColor: Colors.grey,
                  expansionFactor: 2,
                  spacing: 6,
                ),
              ),
              ConstantWidgets.hight10(context),
            ],
          );
        },
      ),
    );
  }
}
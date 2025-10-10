import 'package:barber_pannel/core/images/app_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/app_colors.dart';

class TabbarImageShow extends StatelessWidget {
  const TabbarImageShow({super.key});

  @override
  Widget build(BuildContext context) {
    return loadingImage();
  }

  Shimmer loadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? AppPalette.greyColor,
      highlightColor: AppPalette.whiteColor,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.zero,
            ),
            child: Image.asset(
              AppImages.appLogo,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
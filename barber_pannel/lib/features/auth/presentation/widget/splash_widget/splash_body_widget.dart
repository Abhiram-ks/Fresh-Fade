
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_image.dart';
import '../../../../../core/themes/app_colors.dart';

class SplashBodyWidget extends StatelessWidget {
  const SplashBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.appLogo,
                  fit: BoxFit.contain,
                  height: 70,
                  width: 70,
                ),
                ConstantWidgets.hight10(context),
                Text(
                  "Fresh Fade",
                  style: GoogleFonts.bellefair(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.whiteColor,
                  ),
                ),
                Text(
                  "Business Portel",
                  style: GoogleFonts.poppins(fontSize: 10,color: AppPalette.whiteColor),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: AppPalette.whiteColor,
                color: AppPalette.greyColor,
              ),
            ),
            ConstantWidgets.width40(context),
            Text(
              "Loading...",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppPalette.whiteColor,
              ),
            ),
          ],
        ),
        ConstantWidgets.hight30(context),
        Text(
          'Innovate, Execute, Succeed',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppPalette.whiteColor,
          ),
        ),
        ConstantWidgets.hight30(context),
      ],
    );
  }
}

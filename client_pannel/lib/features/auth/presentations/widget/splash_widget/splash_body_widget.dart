import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
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
                  AppImages.splashLogo,
                  fit: BoxFit.contain,
                  height: 80,
                  width: 80,
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
                  "A Smart Booking Application",
                  style: GoogleFonts.poppins(fontSize: 9,color: AppPalette.whiteColor),
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
                backgroundColor: AppPalette.orengeColor,
                color: AppPalette.hintColor,
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
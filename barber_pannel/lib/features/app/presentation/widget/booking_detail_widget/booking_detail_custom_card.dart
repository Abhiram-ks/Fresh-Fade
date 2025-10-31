
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox paymentSectionBarberData(
    {required BuildContext context,
    required String imageURl,
    required String shopName,
    required String shopAddress,
    required String email,
    required double screenWidth,
    required double screenHeight,
    Color? textColor,
    Color? addressColor}) {
  return SizedBox(
    height: screenHeight * 0.12,
    child: Row(
      children: [
        ConstantWidgets.width20(context),
        Flexible(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: (imageURl.startsWith('http'))
                ? imageshow(
                    imageUrl: imageURl, imageAsset: AppImages.appLogo)
                : Image.asset(
                    AppImages.appLogo,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
          ),
        ),
        ConstantWidgets.width20(context),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:textColor ?? AppPalette.whiteColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                profileviewWidget(
                  screenWidth,
                  context,
                  Icons.location_on,
                  shopAddress,
                  AppPalette.redColor,
                  maxLines: 2,
                  textColor:addressColor ?? AppPalette.whiteColor,
                ),
                Text(
                  email,
                  style: GoogleFonts.plusJakartaSans(color:textColor ?? AppPalette.whiteColor, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ConstantWidgets.width40(context),
              ],
            ),
          ),
        ),
        ConstantWidgets.width20(context),
      ],
    ),
  );
}

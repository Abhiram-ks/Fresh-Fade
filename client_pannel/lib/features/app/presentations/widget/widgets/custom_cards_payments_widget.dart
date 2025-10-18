import 'package:client_pannel/features/app/presentations/screen/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';

SizedBox paymentSectionBarberData(
    {required BuildContext context,
    required String imageURl,
    required String shopName,
    required String shopAddress,
    required double ratings,
    required double screenWidth,
    Color? locationClr,
    required double screenHeight}) {
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
                    imageUrl: imageURl, imageAsset: AppImages.barberEmpty)
                : Image.asset(
                    AppImages.barberEmpty,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
          ),
        ),
        ConstantWidgets.width20(context),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.whiteColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              profileviewWidget(
                screenWidth,
                context,
                Icons.location_on,
                shopAddress,
                AppPalette.redColor,
                maxline: 2,
                textColor:locationClr ?? AppPalette.hintColor,
              ),
              ConstantWidgets.width40(context),
              RatingBarIndicator(
                rating: ratings,
                unratedColor: AppPalette.hintColor,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: AppPalette.orengeColor,
                ),
                itemCount: 5,
                itemSize: 13.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ),
        ConstantWidgets.width20(context),
      ],
    ),
  );
}

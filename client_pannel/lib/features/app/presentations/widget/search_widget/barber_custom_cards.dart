import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/images/app_images.dart' show AppImages;
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart' show RatingBarIndicator;
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import '../../screen/settings/settings_screen.dart';

class ListForBarbers extends StatelessWidget {
  const ListForBarbers({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.imageURl,
    required this.shopName,
    required this.shopAddress,
   this.rating = 0.0,
    required this.ontap,
    required this.isBlocked,
  });

  final double screenHeight;
  final double screenWidth;
  final String imageURl;
  final String shopName;
  final String shopAddress;
  final double rating;
  final VoidCallback ontap;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isBlocked) {
          CustomSnackBar.show(
             context,
            message: 'This shop account has been suspended due to unauthorized activity detected.',
            backgroundColor: AppPalette.redColor,
            textAlign: TextAlign.center,
          );
        } else {
          ontap();
        }
      },
      child: SizedBox(
        height: screenHeight * 0.12,
        child: Row(
          children: [
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
            SizedBox(width: screenWidth * .015),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ConstantWidgets.hight10(context),
                        profileviewWidget(
                          screenWidth,
                          context,
                          Icons.location_on,
                          shopAddress,
                          AppPalette.greyColor,
                          maxline: 1,
                          textColor: AppPalette.greyColor,
                        ),
                        RatingBarIndicator(
                          rating: rating,
                          unratedColor: AppPalette.hintColor,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: AppPalette.buttonColor,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 20,
                    child: Text(
                      isBlocked ? "Suspended" : "Open",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            isBlocked ? AppPalette.redColor : AppPalette.greenColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

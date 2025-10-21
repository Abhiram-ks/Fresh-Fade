
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../domain/entity/barber_entity.dart';
import '../../screen/settings/settings_screen.dart';

class DetailsReviewWidget extends StatelessWidget {
  final BarberEntity barber;
  final double screenWidth;
  final double screenHight;
  const DetailsReviewWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ratings & Reviews',style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  profileviewWidget(
                    screenWidth,
                    context,
                    Icons.verified,
                    'by varified Customers',
                    textColor: AppPalette.greyColor,
                    AppPalette.blueColor,
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {showReviewDetisSheet(context, screenHight, screenWidth, barber.uid);
                  },icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
          ConstantWidgets.hight30(context),
          Row(
            children: [
              Text('${(barber.rating ?? 0.0).toStringAsFixed(1)} / 5',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              ConstantWidgets.width20(context),
              RatingBarIndicator(
                rating: barber.rating ?? 0.0,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: AppPalette.blackColor,
                ),
                itemCount: 5,
                itemSize: 25.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          ConstantWidgets.hight10(context),
          Text( 'Ratings and reiews are varified and are from people who use the same type of device that you use ⓘ',
          )
        ],
      ),
    );
  }
}



void showReviewDetisSheet(BuildContext context, double screenHeight,
    double screenWidth, String shopId) {
  showModalBottomSheet(
    backgroundColor: AppPalette.whiteColor,
    context: context,
    enableDrag: true,
    useSafeArea: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return  SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * .05, vertical: screenHeight * 0.08),
              child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.appLogo, height: 45, width: 45,),
              Text("Unable to proceed with the request.", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              Text("While processing your request, a failure occurred due to an issue with ratings and reviews data management. Please contact the administration team for assistance.", style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
            ],
          ),
        )
            ),
          ),
      );
    },
  );
}
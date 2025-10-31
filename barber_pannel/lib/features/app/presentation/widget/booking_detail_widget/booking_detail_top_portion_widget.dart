
import 'dart:ui';

import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/chat/user_detail_view.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detail_custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class TopPortionWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  const TopPortionWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      child: Center(child:
          BlocBuilder<FetchUserBloc, FetchUserState>(builder: (context, state) {
        if (state is FetchUserLoaded) {
          final user = state.user;
          return ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: screenHeight * 0.13,
                    width: screenWidth * 0.77,
                    color: AppPalette.buttonColor,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserProfileScreen(userId: user.id)));
                      },
                      child: paymentSectionBarberData(
                          context: context,
                          imageURl: user.photoUrl,
                          shopName: user.name ,
                          shopAddress: user.address ?? 'No address information available at this time',
                          email: user.email,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                    ),
                  )));
        }
        return Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.hintColor,
            highlightColor: AppPalette.whiteColor,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    height: screenHeight * 0.13,
                    width: screenWidth * 0.77,
                    color: AppPalette.hintColor.withAlpha((0.5 * 255).toInt()),
                    alignment: Alignment.center,
                    child: paymentSectionBarberData(
                        context: context,
                        imageURl: AppImages.appLogo,
                        shopName: 'Name not available',
                        shopAddress: 'No address information available at this time',
                        email: 'userxyz@gmail.com',
                        screenHeight: screenHeight,
                        screenWidth: screenWidth),
                  ),
                )));
      })),
    );
  }
}

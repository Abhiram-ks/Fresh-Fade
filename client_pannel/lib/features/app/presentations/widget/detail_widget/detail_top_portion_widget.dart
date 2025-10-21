import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:client_pannel/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/common/custom_snackbar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/call/call_service.dart';
import '../../../../../service/share/share_service.dart';
import '../../screen/settings/settings_screen.dart';
import '../../state/bloc/location_bloc/location_bloc.dart';
import 'deatil_iconfileed_widget.dart';

class DetailTopPortionWidget extends StatelessWidget {
  const DetailTopPortionWidget({
    super.key,
    required this.screenWidth,
    required this.barber,
  });

  final double screenWidth;
  final BarberEntity barber;

  @override
  Widget build(BuildContext context) {
    final AuthLocalDatasource localDB = AuthLocalDatasource();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConstantWidgets.hight20(context),
          Text(
            barber.ventureName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          ConstantWidgets.hight10(context),
          profileviewWidget(
            screenWidth,
            context,
            Icons.location_on,
            barber.address,
            AppPalette.greyColor,
            maxline: 2,
            widget: double.infinity,
            textColor: AppPalette.greyColor,
          ),
          ConstantWidgets.hight10(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profileviewWidget(
                screenWidth,
                context,
                Icons.star,
                '${barber.rating.toStringAsFixed(1)} (Customer Reviews)',
                AppPalette.buttonColor,
                maxline: 1,
                textColor: AppPalette.greyColor,
              ),
              Text(
                () {
                  final gender = barber.gender?.toLowerCase();
                  if (gender == 'male') return 'Male';
                  if (gender == 'female') return 'Female';
                  return 'Unisex';
                }(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      (() {
                        final gender = barber.gender?.toLowerCase();
                        if (gender == 'male') return AppPalette.blueColor;
                        if (gender == 'female') return Colors.pink;
                        return AppPalette.orengeColor;
                      })(),
                ),
              ),
              Text(
                "Open",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.greenColor,
                ),
              ),
            ],
          ),
          ConstantWidgets.hight20(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                detailsPageActions(
                  context: context,
                  screenWidth: screenWidth,
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  onTap: () async {
                    try {
                      final String? userId = await localDB.get();
                      if (userId == null || userId.isEmpty) {
                        if (context.mounted) {
                          CustomSnackBar.show(
                            context,
                            message: 'Token expired. Please login again.',
                            backgroundColor: AppPalette.redColor,
                            textAlign: TextAlign.center,
                          );
                        }
                        return;
                      }
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.chatWindow,
                          arguments: {'barberId': barber.uid, 'userId': userId},
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        CustomSnackBar.show(
                          context,
                          message:
                              'Unable to access chat window. ${e.toString()}',
                          backgroundColor: AppPalette.redColor,
                          textAlign: TextAlign.center,
                        );
                      }
                    }
                    // final credentials =
                    //     await SecureStorageService.getUserCredentials();
                    // final String? userId = credentials['userId'];
                    // if (userId == null) return;

                    // Navigator.push(
                    //   // ignore: use_build_context_synchronously
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => IndividualChatScreen(
                    //       barberId: barber.uid,
                    //       userId: userId,
                    //     ),
                    //   ),
                    // );
                  },
                  text: 'Message',
                ),
                detailsPageActions(
                  context: context,
                  screenWidth: screenWidth,
                  icon: Icons.phone_in_talk_rounded,
                  onTap: () {
                    CallHelper.makeCall(barber.phoneNumber, context);
                  },
                  text: 'Call',
                ),
                detailsPageActions(
                  context: context,
                  screenWidth: screenWidth,
                  icon: Icons.location_on_sharp,
                  onTap: () async {
                    try {
                      final position =
                          await context
                              .read<LocationBloc>()
                              .getLocationUseCase();
                      final barberLatLng =
                          await GeocodingHelper.addressToLatLng(barber.address);

                      await MapHelper.openGoogleMaps(
                        sourceLat: position.latitude,
                        sourceLng: position.longitude,
                        destLat: barberLatLng.latitude,
                        destLng: barberLatLng.longitude,
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      CustomSnackBar.show(
                        context,
                        message: 'Unable to Access Directions. ${e.toString()}',
                        backgroundColor: AppPalette.redColor,
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                  text: 'Direction',
                ),
                // BlocBuilder<FetchWishlistSinglebarberCubit, FetchWishlistSinglebarberState>(
                //   builder: (context, state) {
                // bool isLiked = false;
                // if (state is FetchWishlistSinglebarberLoaded) {
                //   isLiked = state.isLiked;
                // }

                //   return
                detailsPageActions(
                  context: context,
                  colors: AppPalette.buttonColor,
                  // isLiked ? AppPalette.redColor : const Color(0xFFFEBA43),
                  screenWidth: screenWidth,
                  icon: CupertinoIcons.heart_fill,
                  onTap: () async {
                    // context.read<WishlistFunctionCubit>().toggleWishlist(
                    //       barberId: barber.uid,
                    //       isCurrentlyLiked: isLiked,
                    //     );
                  },
                  text: 'Favorite',
                ),
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


import 'dart:ui';

import 'package:client_pannel/features/app/presentations/state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/widgets/custom_cards_payments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';

Expanded nerbyWorkShopDetailsWIdget( {required double screenHeight, required double screenWidth}) {
  return Expanded(
    child: SizedBox(
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Center(
            child: SizedBox(
              height: screenHeight * 0.13,
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoaded) {
                    final barbers = state.barbers;
                    if (barbers.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppPalette.greyColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppPalette.orengeColor
                                ),
                                child: Icon(
                                  Icons.search_off_rounded,
                                  color: AppPalette.orengeColor,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No shops found',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try adjusting the distance filter',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: AppPalette.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        itemCount: barbers.length,
                        separatorBuilder: (_, __) =>
                            ConstantWidgets.width20(context),
                        itemBuilder: (context, index) {
                          final barber = barbers[index];

                          return FutureBuilder<String>(
                            future: getFormattedAddress(barber.lat, barber.lng),
                            builder: (context, snapshot) {
                              final address = snapshot.data ?? barber.address;

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    width: screenWidth * 0.77,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppPalette.blackColor.withAlpha((0.75 * 255).toInt()),
                                          AppPalette.blackColor.withAlpha((0.65 * 255).toInt()),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppPalette.orengeColor.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: paymentSectionBarberData(
                                      context: context,
                                      imageURl: AppImages.barberEmpty,
                                      shopName:
                                          '${barber.name} • ${barber.distance} km',
                                      shopAddress: address,
                                      ratings: barber.distance,
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  }
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        itemCount: 3,
                        separatorBuilder: (_, __) =>
                            ConstantWidgets.width20(context),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: AppPalette.greyColor.withValues(alpha: 0.3),
                            highlightColor: AppPalette.whiteColor.withValues(alpha: 0.2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  width: screenWidth * 0.77,
                                  decoration: BoxDecoration(
                                    color: AppPalette.greyColor
                                        .withAlpha((0.3 * 255).toInt()),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppPalette.hintColor.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: paymentSectionBarberData(
                                    context: context,
                                    imageURl: '',
                                    shopName: 'Loading shop details...',
                                    shopAddress: 'Please wait while we search nearby',
                                    ratings: 0,
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                    locationClr: AppPalette.hintColor
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
}

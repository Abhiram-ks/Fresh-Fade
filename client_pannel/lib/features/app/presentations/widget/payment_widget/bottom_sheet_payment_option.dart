import 'package:client_pannel/core/images/app_images.dart';
import 'package:lottie/lottie.dart';
import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSheetPaymentOption {
  void showBottomSheet({
    required BuildContext context,
    required VoidCallback walletPaymentAction,
    required VoidCallback stripePaymentAction,
    required double screenWidth,
    required double screenHeight,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppPalette.whiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final double itemWidth  = (screenWidth * 0.9) / 2;
        final double itemHeight = itemWidth; 

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantWidgets.hight10(context),
              Text(
                "Choose Your Payment Method",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Available Payment Method Pay by Cash tap to proceed. Procees make end-to-end secure transaction.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppPalette.blackColor,
                ),
              ),
              ConstantWidgets.hight30(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: walletPaymentAction,
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieFilesCommon.load(
                            assetPath: AppImages.walletLottie,
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pay by Cash',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: stripePaymentAction,
                    
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteColor,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieFilesCommon.load(
                            assetPath: AppImages.cardLottie,
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Online payment',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}


class LottieFilesCommon {
  LottieFilesCommon._();

  static Widget load({
    required String assetPath,
    required double width,
    required double height,
  }) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
    );
  }
}
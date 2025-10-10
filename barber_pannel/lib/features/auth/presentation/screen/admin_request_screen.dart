

import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/constant/mediaquary_helper.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/custom_lottie.dart';
import '../../../../core/images/app_image.dart';
import '../../../../core/routes/routes.dart';

class AdminRequest extends StatelessWidget {
  const AdminRequest({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHight = MeidaQuaryHelper.height(context);
    double screenWidth = MeidaQuaryHelper.width(context);

    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
          return false;
        },
        child: ColoredBox(
          color: AppPalette.buttonColor,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: AppPalette.whiteColor,
                  iconTheme: IconThemeData(color: AppPalette.blackColor),
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false);
                      }),
                ),
                 body: Padding(
                   padding: EdgeInsets.symmetric( horizontal: screenWidth > 600 ? screenWidth *.3 : screenWidth * 0.08),
                   child: ListView(
                    children: [
                      AdminRequestWidget(screenWidth: screenWidth, screenHight: screenHight)
                    ],
                   ),
                  )
              ),
          ),
        )
        );
  }
}


class AdminRequestWidget extends StatelessWidget {
  const AdminRequestWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
  });

  final double screenWidth;
  final double screenHight;

  final String _email =  "freshfade.growblic@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Verification Process.',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(
          'Your request for admin verification has been received. Our team will review your submission and send you a confirmation email once the verification process is complete. The verification process typically takes 24 to 72 hours. Please ensure you respond to any follow-up requests from our team. \nThank you',
        ),
        LottiefilesCommon(assetPath: AppImages.requestW8, width: screenWidth*0.5, height: screenHight*0.5),
        Text(
          'Contact Us:',
          style: GoogleFonts.plusJakartaSans(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: ()async {
            final Uri emialUri = Uri(
              scheme: 'mailto',
              path: _email,
              query: 'subject=${Uri.encodeComponent("Need Help")}&body=${Uri.encodeComponent("Hello Team Cavalog,\n\nI need help with...")}',
            );
            try {
              await launchUrl(emialUri);
            } catch (e) {
              if (!context.mounted) return;
              CustomSnackBar.show(context, message: 'Unable to open the email app at this time. Try opening your email manually. Error: $e', backgroundColor: AppPalette.redColor,  textColor: AppPalette.whiteColor);
            }
          },
          
           child: Text(
           _email,
            style: TextStyle(
              color: AppPalette.buttonColor,
            ),
           ),
        ),
           Text(
          "With appreciation, Team Fresh Fade",
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
}

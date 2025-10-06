import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String greeting = _getGreeting();
    final String formattedDate = _formatDate(now);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppPalette.blueColor,
            AppPalette.blueColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.blackColor.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.whiteColor,
                      ),
                    ),
                    ConstantWidgets.hight5(context),
                    Text(
                      'Welcome back to Fresh Fade Admin',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppPalette.whiteColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppPalette.whiteColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppPalette.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          ConstantWidgets.hight15(context),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppPalette.whiteColor,
                size: 20,
              ),
              ConstantWidgets.width5(context),
              Text(
                'Business is growing steadily',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppPalette.whiteColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
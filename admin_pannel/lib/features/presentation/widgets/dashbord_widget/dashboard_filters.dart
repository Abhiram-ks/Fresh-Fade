import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class DashboardFilters extends StatelessWidget {
  final IconData icon;
  final VoidCallback action;
  final String message;
  const DashboardFilters({required this.action, required this.icon,required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message, 
      waitDuration: const Duration(
        milliseconds: 500,
      ), 
      showDuration: const Duration(seconds: 2), 
      child: Container(
        height: 50,
        width: 50,

        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: IconButton(
          splashColor: Colors.white,
          highlightColor: AppPalette.hintColor,
          focusColor: AppPalette.greyColor,
          onPressed: action,

          icon: Icon(icon, color: AppPalette.blueColor),
        ),
      ),
    );
  }
}

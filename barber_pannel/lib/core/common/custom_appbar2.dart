import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final Color? backgroundColor;
  final bool? isTitle;
  final Color? titleColor;
  final Color? iconColor;
  final List<Widget>? actions; 
  const CustomAppBar2({
    super.key,
    this.title,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.isTitle = false,
    this.actions, 
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppPalette.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppPalette.blackColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        centerTitle: true,
        title: isTitle == true
            ? Text(
                title!,
                style: GoogleFonts.poppins(
                  color: titleColor ?? Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
                ),
                textAlign: TextAlign.center,
                
              )
            : null,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: iconColor ?? AppPalette.blackColor),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: actions,
      ),
    );
  }
}

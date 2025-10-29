import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/app_colors.dart';


// custom appbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final String? text;
  final Color? iconColor;
  final String? title;
   final bool? isTitle;

  const CustomAppBar({super.key, this.onPressed, this.iconColor, this.text, this.backgroundColor,this.isTitle = false,this.title, })
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isTitle == true
          ? Text(
              title ?? 'Unknown',
              style:  TextStyle(
                color:iconColor ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      backgroundColor:backgroundColor ?? AppPalette.whiteColor,
      iconTheme: IconThemeData(color:iconColor ?? AppPalette.blackColor),
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: text != null 
              ? [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextButton(
                    onPressed: onPressed, 
                    child: Text(text ?? 'Unknown',style: TextStyle(color:iconColor, fontWeight: FontWeight.bold),
                    ))
                )
              ] : []
    );
  }
}


// custom appbar with button


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
        backgroundColor: backgroundColor ?? AppPalette.blackColor,
        
        iconTheme: IconThemeData(color: iconColor ?? AppPalette.blackColor),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: actions,
      ),
    );
  }
}

import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

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

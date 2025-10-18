import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';

InkWell serviceTags(
    {required VoidCallback onTap,required String text,required bool isSelected}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? AppPalette.greyColor : AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppPalette.greyColor : AppPalette.hintColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5, vertical: 3,
      ),
      child: Text(text,
          style: TextStyle(fontSize: 14,color: isSelected ? AppPalette.whiteColor : AppPalette.greyColor)),
    ),
  );
}

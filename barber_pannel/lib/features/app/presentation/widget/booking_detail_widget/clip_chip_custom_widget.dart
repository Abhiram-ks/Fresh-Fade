

import 'package:flutter/material.dart';

import '../../../../../core/constant/constant.dart';

class ClipChipMaker {
  static Widget build({
    required String text,
    required Color actionColor, 
    required Color textColor,
    required Color backgroundColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: actionColor,
          hoverColor: actionColor,
          child: Chip(
            label: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor:backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side:  BorderSide(
                style: BorderStyle.solid,
                color: borderColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Row paymentSummaryTextWidget(
    {required BuildContext context,
    required String prefixText,
    required String suffixText,
    required TextStyle suffixTextStyle,
    required TextStyle prefixTextStyle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          prefixText,
          style: suffixTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ConstantWidgets.width40(context),
      Text(
        suffixText,
        style: prefixTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

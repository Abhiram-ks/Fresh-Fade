
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../themes/app_colors.dart';

class LocationTextformWidget {
  static Widget locationAccessField({
    required String label,
    required String hintText,
    required IconData prefixIcon,
    required IconData suffixIcon,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required Color prefixClr,
    required Color suffixClr,
    required VoidCallback action,
    required BuildContext context,
    int minLines = 1,
    int maxLines = 1,
    bool enabled = true
  }){
       return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
                 TextFormField(
              controller: controller,
              validator: validator,
              obscureText: false,
              style: const TextStyle(fontSize: 16),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: enabled,
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppPalette.hintColor),
                prefixIcon: InkWell(
                  onTap:  action,
                  child: Icon(
                    prefixIcon,
                    color: prefixClr,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap:  action,
                  child: Icon(
                    suffixIcon,
                    color: suffixClr,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPalette.hintColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppPalette.buttonColor, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppPalette.redColor,
                    width: 1,
                  ),
                ),
                 errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppPalette.redColor,
                    width: 1,
                  ),
                )
              ),
            ),
        ConstantWidgets.hight10(context),
      ],
    );
  }
}
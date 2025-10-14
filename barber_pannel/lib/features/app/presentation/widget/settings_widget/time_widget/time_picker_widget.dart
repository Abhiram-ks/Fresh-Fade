
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/themes/app_colors.dart';


TextButton timePickerwidget({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(Time) onTimeChanged,
  required String labelText,
}) {
  return TextButton(
    onPressed: () {
      Navigator.of(context).push(
        showPicker(
            is24HrFormat: true,
            context: context,
            value: Time.fromTimeOfDay(initialTime, 0),
            onChange: onTimeChanged,
            duskSpanInMinutes: 120,
            blurredBackground: true,
            iosStylePicker: true,
            focusMinutePicker: true,
            okText: 'schedule',
            backgroundColor: AppPalette.whiteColor,
            cancelStyle: TextStyle(color: AppPalette.blackColor),
            okStyle: TextStyle(
              color: AppPalette.buttonColor,
            )),
      );
    },
    child: Text(
      "$labelText :",
      style: TextStyle(
        color: AppPalette.buttonColor,
        fontSize: 16,
      ),
    ),
  );
}


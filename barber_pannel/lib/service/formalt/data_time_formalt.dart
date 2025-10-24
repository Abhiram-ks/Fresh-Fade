/*-------------------------------------------------------
  Handle for checking if the slot's date and time 
  occurs before the current session (now).
-------------------------------------------------------*/

import 'package:intl/intl.dart';
import '../../features/app/data/model/date_model.dart';

bool isSlotTimeExceeded(String dateStr, String timeStr) {
  try {
    final cleanedTime = timeStr.replaceAll('\u202F', ' ');
    final fullDateTime = "$dateStr $cleanedTime";

    final format = DateFormat("dd-MM-yyyy h:mm a");
    final slotDateTime = format.parse(fullDateTime);

    final now = DateTime.now();
    return slotDateTime.isBefore(now);
  } catch (e) {
    return false;
  }
}

/*-------------------------------------------------------
  Slot formatting to readable time string 
  from DateTime → Example: 12:00 AM, 1:00 PM
-------------------------------------------------------*/

String formatTimeRange(DateTime startTime) {
  final String time = DateFormat.jm().format(startTime);
  return time;
}

/*-------------------------------------------------------
  Handle date formatting: Parse date string into 
  year, month, and day components
-------------------------------------------------------*/

DateTime parseDate(String dateString) {
  final parts = dateString.split('-');
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}

/*-------------------------------------------------------
  Handle calendar date selection by disabling specific 
  dates such as past dates, weekends, or dates with 
  booked slots from Firestore using selectableDayPredicate.
-------------------------------------------------------*/

Set<DateTime> getDisabledDates(List<DateModel> dates) {
  return dates.map((dateModel) => parseDate(dateModel.date)).toSet();
}
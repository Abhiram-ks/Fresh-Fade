import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddressFormatter {
  static String formatAddress(Placemark place) {
    String address = "";

    if (place.street != null && place.street!.isNotEmpty) {
      address = place.street!;
    } else if (place.name != null &&
        place.name!.isNotEmpty &&
        !place.name!.contains('+')) {
      address = place.name!;
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      address +=
          address.isEmpty ? place.subLocality! : ", ${place.subLocality!}";
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      address += address.isEmpty ? place.locality! : ", ${place.locality}";
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      address += address.isEmpty
          ? place.administrativeArea!
          : ", ${place.administrativeArea}";
    }
    if (place.country != null && place.country!.isNotEmpty) {
      address += address.isEmpty ? place.country! : ", ${place.country}";
    }

    return address;
  }
}


Future<String> getFormattedAddress(double lat, double lng) async {
  try {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      return AddressFormatter.formatAddress(placemarks.first);
    }
    return "Address not found";
  } catch (e) {
    return "Error getting address";
  }
}




/*-------------------------------------------------------
  Handle for checking if the slot's date and time 
  occurs before the current session (now).
-------------------------------------------------------*/


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

// Set<DateTime> getDisabledDates(List<DateModel> dates) {
//   return dates.map((dateModel) => parseDate(dateModel.date)).toSet();
// }



/*-------------------------------------------------------
/// Formats a numeric amount into a human-readable Indian currency string.
///
/// Converts a given `double` value into a string formatted in the standard Indian
/// currency style with comma separators and two decimal places. This function does
/// not use `NumberFormat` from intl package and instead applies manual formatting
/// for simplicity.
///
/// Example:
/// ```dart
/// formatCurrency(1234567.89); // returns '₹12,34,567.89'
/// ```
///
/// - [amount]: The numeric amount to format (e.g., 123456.78).
/// - Returns: A string in Indian Rupee format with ₹ symbol and commas.
///
/// Note: This function currently formats only positive numbers and assumes input
/// is a valid `double`.
-------------------------------------------------------*/

String formatCurrency(double amount) {
  final formatted = amount.toStringAsFixed(2);
  final parts = formatted.split('.');
  final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  return '₹$intPart.${parts[1]}';
}


String formatDate(DateTime dateTime) {
  final dateFormat = DateFormat('dd MMM yyyy');
  return dateFormat.format(dateTime);
}

DateTime dateConverter(String dateString) {
  final DateFormat formatter = DateFormat("dd/MM/yyyy - HH:mm");
  return formatter.parse(dateString);
}

String formatDateToSlotDocId(DateTime date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}

/// Converts "dd-MM-yyyy" string back to DateTime
DateTime parseSlotDocIdToDate(String formattedDate) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.parse(formattedDate);
}


// Converts "dd-MM-yyyy" string to "dd/MM/yyyy - HH:mm" format
/// This is useful for displaying the date in a more readable format and for open ai conversation
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}


//Generate a random 6 digit number
class GenerateBookingOtp {
  String generateOtp() {
    final random = Random();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }
}
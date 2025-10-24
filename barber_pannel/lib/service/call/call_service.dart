import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/common/custom_snackbar.dart';
import '../../core/themes/app_colors.dart';

class CallHelper {
  ///  Check if device supports phone calls
  static Future<bool> _canMakePhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    return await canLaunchUrl(telUri);
  }

  /// Request phone call permission (for direct calling only)
  static Future<bool> _requestPhonePermission() async {
    try {
      var status = await Permission.phone.status;

      if (status.isGranted) return true;
      if (status.isDenied) {
        status = await Permission.phone.request();
        return status.isGranted;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Fallback method using `url_launcher` (no permission required)
  static Future<bool> _makeCallWithUrlLauncher(String phoneNumber) async {
    try {
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
      return await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  /// Main call method with proper handling
  static Future<void> makeCall(String phoneNumber, BuildContext context) async {
    try {
      final canCall = await _canMakePhoneCall(phoneNumber);
      if (!canCall) {
        if (!context.mounted) return;
        CustomSnackBar.show(
          context,
          message: 'This device does not support phone calls.',
          backgroundColor: AppPalette.redColor,
          textColor: AppPalette.whiteColor,
        );
        return;
      }

      bool callSuccess = false;

      // Try direct call first (Android only)
      if (Platform.isAndroid) {
        final hasPermission = await _requestPhonePermission();
        if (hasPermission) {
          try {
            await FlutterPhoneDirectCaller.callNumber(phoneNumber);
            callSuccess = true;
          } catch (_) {
            callSuccess = false;
          }
        }
      }

      // If direct call fails or permission denied, fallback
      if (!callSuccess) {
        callSuccess = await _makeCallWithUrlLauncher(phoneNumber);
      }

      if (!callSuccess) {
        if (!context.mounted) return;
        _handleCallError(context, 'Unable to initiate the call.');
      }
    } on PlatformException catch (e) {
      if (!context.mounted) return;
      _handlePlatformException(context, e);
    } catch (e) {
      if (!context.mounted) return;
      _handleCallError(context, 'Something went wrong: ${e.toString()}');
    }
  }

  /// Error handling for platform issues
  static void _handlePlatformException(BuildContext context, dynamic exception) {
    String message = 'Unable to make call.';
    if (exception.toString().contains('No SIM')) {
      message = 'No SIM card detected. Please insert a SIM card.';
    } else if (exception.toString().contains('permission')) {
      message = 'Phone permission denied.';
    } else if (exception.toString().contains('airplane')) {
      message = 'Please disable airplane mode.';
    }
    CustomSnackBar.show(
      context,
      message: message,
      backgroundColor: AppPalette.redColor,
      textColor: AppPalette.whiteColor,
    );
  }

  static void _handleCallError(BuildContext context, String error) {
    CustomSnackBar.show(
      context,
      message: error,
      backgroundColor: AppPalette.redColor,
      textColor: AppPalette.whiteColor,
    );
  }
}
// 
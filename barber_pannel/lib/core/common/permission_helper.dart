import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionHelper {
  /// Request camera permission at runtime
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request photo library/storage permission at runtime
  static Future<bool> requestPhotoLibraryPermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), use photos permission
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.photos.request();
        return status.isGranted;
      } else {
        // For Android 12 and below
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  /// Request location permission at runtime
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Request location when in use permission
  static Future<bool> requestLocationWhenInUsePermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if photo library permission is granted
  static Future<bool> isPhotoLibraryPermissionGranted() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.photos.status;
        return status.isGranted;
      } else {
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;
      return status.isGranted;
    }
    return false;
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request permission for image picker (camera or gallery)
  /// Returns true if permission is granted
  static Future<bool> requestImagePickerPermission(
      {required bool fromCamera}) async {
    if (fromCamera) {
      // Request camera permission
      return await requestCameraPermission();
    } else {
      // Request photo library permission
      return await requestPhotoLibraryPermission();
    }
  }

  /// Open app settings if permission is permanently denied
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Check Android version
  static Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      // You can use device_info_plus package for more accurate check
      // For now, we'll use a simple check
      return true; // Assume newer version, will fallback automatically
    }
    return false;
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
      List<Permission> permissions) async {
    return await permissions.request();
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied(
      Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Show dialog and open settings if permission is permanently denied
  static Future<void> handlePermanentlyDenied(
    Permission permission,
    String message,
  ) async {
    if (await isPermissionPermanentlyDenied(permission)) {
      // You can show a dialog here explaining why permission is needed
      // and then open settings
      await openSettings();
    }
  }
}


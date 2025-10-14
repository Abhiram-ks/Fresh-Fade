import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromCamera() async {
    final PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
        if (image != null) {
          return File(image.path);
        }
      } catch (e) {
        throw Exception('Error picking image from camera: $e');
      }
    } else if (cameraStatus.isDenied) {
      throw Exception('Camera permission denied');
    } else if (cameraStatus.isPermanentlyDenied) {
      throw Exception('Camera permission permanently denied. Opening settings...');
    }
    return null;
  }


  static Future<File?> pickImageFromGallery() async {
    PermissionStatus storageStatus;

    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        storageStatus = await Permission.photos.request();
      } else {
        storageStatus = await Permission.storage.request();
      }
    } else {
      storageStatus = await Permission.photos.request();
    }

    if (storageStatus.isGranted || storageStatus.isLimited) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          return File(image.path);
        }
      } catch (e) {
        throw Exception('Error picking image from gallery: $e');
      }
    } else if (storageStatus.isDenied) {
      throw Exception('Storage permission denied');
    } else if (storageStatus.isPermanentlyDenied) {
      throw Exception('Storage permission permanently denied. Opening settings...');
    }
    return null;
  }

  /// Pick multiple images from gallery with runtime permission request
  static Future<List<File>> pickMultipleImagesFromGallery() async {
    PermissionStatus storageStatus;

    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        storageStatus = await Permission.photos.request();
      } else {
        storageStatus = await Permission.storage.request();
      }
    } else {
      storageStatus = await Permission.photos.request();
    }

    if (storageStatus.isGranted || storageStatus.isLimited) {
      try {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 80,
        );
        return images.map((xFile) => File(xFile.path)).toList();
      } catch (e) {
        throw Exception('Error picking multiple images: $e');
      }
    } else if (storageStatus.isDenied) {
      throw Exception('Storage permission denied');
    } else if (storageStatus.isPermanentlyDenied) {
      throw Exception('Storage permission permanently denied. Opening settings...');
    }
    return [];
  }

  /// Show bottom sheet to choose between camera and gallery
  /// Returns the selected image file
  static Future<File?> showImageSourceBottomSheet({
    required Function(ImageSource) onSourceSelected,
  }) async {
    // This will be called from your UI code
    // The actual bottom sheet should be shown in your UI layer
    return null;
  }

  /// Pick image with custom quality
  static Future<File?> pickImage({
    required ImageSource source,
    int imageQuality = 80,
    double? maxWidth,
    double? maxHeight,
  }) async {
    // Request appropriate permission based on source
    PermissionStatus permissionStatus;

    if (source == ImageSource.camera) {
      permissionStatus = await Permission.camera.request();
    } else {
      if (Platform.isAndroid) {
        if (await _isAndroid13OrHigher()) {
          permissionStatus = await Permission.photos.request();
        } else {
          permissionStatus = await Permission.storage.request();
        }
      } else {
        permissionStatus = await Permission.photos.request();
      }
    }

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      try {
        final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
        if (image != null) {
          return File(image.path);
        }
      } catch (e) {
        throw Exception('Error picking image: $e');
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      throw Exception('Permission permanently denied. Opening settings...');
    }
    return null;
  }

  /// Check Android version (simplified)
  static Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      // In a real app, you should use device_info_plus package
      // to get accurate Android version
      return true; // Assume newer version
    }
    return false;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if photo/storage permission is granted
  static Future<bool> isGalleryPermissionGranted() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.photos.status;
        return status.isGranted || status.isLimited;
      } else {
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    } else {
      final status = await Permission.photos.status;
      return status.isGranted || status.isLimited;
    }
  }
}


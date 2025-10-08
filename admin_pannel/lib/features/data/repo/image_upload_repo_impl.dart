import 'dart:io';

import 'package:admin_pannel/features/domain/repo/image_upload_repo.dart';

import '../../../service/cloudinary/cloudinary_service.dart';

class ImageUploaderMobile implements ImageUploader {
  final CloudinaryService cloudinaryService;

  ImageUploaderMobile(this.cloudinaryService);

  @override
  Future<String?> upload(String imagePath) {
    return cloudinaryService.uploadImage(File(imagePath));
  }
}

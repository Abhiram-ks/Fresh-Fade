import 'dart:typed_data';

abstract class ImagePickerRepository {
  Future<String?> pickImagePath();
  Future<Uint8List?> pickImageBytes();
}
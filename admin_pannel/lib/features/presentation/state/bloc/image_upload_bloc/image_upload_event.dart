part of 'image_upload_bloc.dart';

@immutable
abstract class ImageUploadEvent {
}

class ImageUploadRequested  extends ImageUploadEvent {
  final String imagePath;
  final Uint8List? imageBytes;
  final int index;

  ImageUploadRequested({required this.imagePath, required this.index, this.imageBytes});

}
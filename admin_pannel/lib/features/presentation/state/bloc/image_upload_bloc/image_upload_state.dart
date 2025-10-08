part of 'image_upload_bloc.dart';

@immutable

abstract class ImageUploadState{}

final class ImageUploadInitial extends ImageUploadState {}
final class ImageUploadLoading extends ImageUploadState {}
final class ImageUploadSuccess extends ImageUploadState {}
final class ImageUploadError   extends ImageUploadState {
  final String error;
  ImageUploadError(this.error);
}

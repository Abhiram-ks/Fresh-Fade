part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostEvent {}

final class UploadPostEventRequest extends UploadPostEvent {
  final String imagePath;
  final String description;

  UploadPostEventRequest({required this.imagePath, required this.description});
}

final class UploadPostConfirmEvent extends UploadPostEvent {}
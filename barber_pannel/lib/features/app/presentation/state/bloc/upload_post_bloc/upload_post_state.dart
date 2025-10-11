part of 'upload_post_bloc.dart';

@immutable
abstract class UploadPostState {}

final class UploadPostInitial extends UploadPostState {}

final class UploadPostAlert extends UploadPostState {}

final class UploadPostLoading extends UploadPostState {}

final class UploadPostSuccess extends UploadPostState {}

final class UploadPostError extends UploadPostState {
  final String error;
  UploadPostError({required this.error});
}
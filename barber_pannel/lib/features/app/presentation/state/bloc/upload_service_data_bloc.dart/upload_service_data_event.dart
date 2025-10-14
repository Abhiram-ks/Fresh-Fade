part of 'upload_service_data_bloc.dart';

@immutable
abstract class UploadServiceDataEvent {}

final class UploadServiceDataRequest extends UploadServiceDataEvent {
    final String imagePath;
    final GenderOption gender;

  UploadServiceDataRequest({required this.imagePath, required this.gender});
}


final class UploadServiceDataConfirmation extends UploadServiceDataEvent {}
part of 'upload_service_data_bloc.dart';

@immutable
abstract class UploadServiceDataState {}

final class UploadServiceDataInitial extends UploadServiceDataState {}


final class UploadServiceDataDialogBox extends UploadServiceDataState {
  final String gender;

    UploadServiceDataDialogBox({required this.gender});
  }
  
final class UploadServiceDataLoading extends UploadServiceDataState {}

final class UploadServiceDataSuccess extends UploadServiceDataState {}

final class UploadServiceDataError extends UploadServiceDataState {
  final String error;

  UploadServiceDataError({required this.error});
}
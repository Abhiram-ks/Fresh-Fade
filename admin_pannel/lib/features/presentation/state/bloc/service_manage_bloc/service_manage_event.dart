part of 'service_manage_bloc.dart';


@immutable
abstract class ServiceMangementEvent{}

final class UploadNewServiceEvent extends ServiceMangementEvent{
  final String serviceName;

  UploadNewServiceEvent({required this.serviceName}); 
}
final class DeleteServiceEvent extends ServiceMangementEvent{
    final String serviceId;
    DeleteServiceEvent(this.serviceId);
}
final class DeleteConfirmation extends ServiceMangementEvent{}
final class EditServiceEvent extends ServiceMangementEvent{
  final String serviceId;
  final String serviceName;

  EditServiceEvent({required this.serviceId, required this.serviceName});
}

final class UpdateServiceEvent extends ServiceMangementEvent {
  final String updatedText;
  UpdateServiceEvent(this.updatedText);
}


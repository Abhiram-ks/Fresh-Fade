part of 'barber_service_modification_bloc.dart';

@immutable
abstract class BarberServiceModificationEvent {}

//! delete service event 
// barberID, Barber serivice key
class DeleteServiceEventRequest extends BarberServiceModificationEvent {
  final String barberID;
  final String serviceKey;

  DeleteServiceEventRequest({required this.barberID, required this.serviceKey});
}

class DeleteServiceEventConfirm extends BarberServiceModificationEvent {}

//! update service event
// barberID, Barber serivice key, Barber serivice rate

final class FetchBarberServiceUpdateRequestEvent extends BarberServiceModificationEvent {
  final String barberID;
  final String serviceKey;
  final double serviceRate;
  final double oldServiceRate;

  FetchBarberServiceUpdateRequestEvent({required this.barberID, required this.serviceKey, required this.serviceRate, required this.oldServiceRate});
}

final class FetchBarberServiceUpdateConfirmEvent extends BarberServiceModificationEvent {}
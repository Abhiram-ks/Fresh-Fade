part of 'location_bloc.dart';

@immutable
abstract class LocationEvent{}

class GetCurrentLocationEvent extends LocationEvent {}

class UpdateLocationEvent extends LocationEvent {
  final LatLng newPosition;
  UpdateLocationEvent(this.newPosition);
}

class CheckLocationPermissionEvent extends LocationEvent {}

class RequestLocationPermissionEvent extends LocationEvent {}

class StartLiveTrackingEvent extends LocationEvent {}

class StopLiveTrackingEvent extends LocationEvent {}

class UpdateLiveLocationEvent extends LocationEvent {
  final LatLng position;
  UpdateLiveLocationEvent(this.position);
}

part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

final class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LatLng position;
  final bool isLiveTracking;
  final bool hasPermission;
  
  LocationLoaded(
    this.position, {
    this.isLiveTracking = false,
    this.hasPermission = true,
  });
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationPermissionDenied extends LocationState {
  final String message;
  LocationPermissionDenied(this.message);
}

class LocationPermissionGranted extends LocationState {}

class LiveTrackingActive extends LocationState {
  final LatLng position;
  LiveTrackingActive(this.position);
}
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../domain/usecase/get_location_usecase.dart';
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationUseCase getLocationUseCase;
  StreamSubscription<Position>? _positionStreamSubscription;
  
  LocationBloc(this.getLocationUseCase) : super(LocationInitial()) {
    on<GetCurrentLocationEvent>((event, emit) async {
      emit(LocationLoading());
      try {
        
        final permissionStatus = await Permission.location.status;
        if (!permissionStatus.isGranted) {
          emit(LocationPermissionDenied("Location permission is required"));
          return;
        }
        
        final position = await getLocationUseCase();
        emit(LocationLoaded(position));
      } catch (e) {
        emit(LocationError("Failed to fetch location: $e"));
      }
    });

    on<UpdateLocationEvent>((event, emit) {
      final currentState = state;
      if (currentState is LocationLoaded) {
        emit(LocationLoaded(
          event.newPosition,
          isLiveTracking: currentState.isLiveTracking,
          hasPermission: currentState.hasPermission,
        ));
      } else {
        emit(LocationLoaded(event.newPosition));
      }
    });

    on<CheckLocationPermissionEvent>((event, emit) async {
      final permissionStatus = await Permission.location.status;
      if (permissionStatus.isGranted) {
        emit(LocationPermissionGranted());
      } else {
        emit(LocationPermissionDenied("Location permission is required"));
      }
    });

    on<RequestLocationPermissionEvent>((event, emit) async {
      emit(LocationLoading());
      final permissionStatus = await Permission.location.request();
      
      if (permissionStatus.isGranted) {
        try {
          final position = await getLocationUseCase();
          emit(LocationLoaded(position, hasPermission: true));
        } catch (e) {
          emit(LocationError("Failed to fetch location: $e"));
        }
      } else if (permissionStatus.isDenied) {
        emit(LocationPermissionDenied("Location permission denied. Please grant permission to use this feature."));
      } else if (permissionStatus.isPermanentlyDenied) {
        emit(LocationPermissionDenied("Location permission permanently denied. Please enable it in app settings."));
      }
    });

    on<StartLiveTrackingEvent>((event, emit) async {
      try {
        final permissionStatus = await Permission.location.status;
        if (!permissionStatus.isGranted) {
          emit(LocationPermissionDenied("Location permission is required for live tracking"));
          return;
        }

        // Cancel any existing subscription
        await _positionStreamSubscription?.cancel();
        
        const locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        );

        _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen(
          (Position position) {
            add(UpdateLiveLocationEvent(
              LatLng(position.latitude, position.longitude),
            ));
          },
          onError: (error) {
            add(StopLiveTrackingEvent());
          },
        );

        final currentPosition = await Geolocator.getCurrentPosition();
        emit(LocationLoaded(
          LatLng(currentPosition.latitude, currentPosition.longitude),
          isLiveTracking: true,
          hasPermission: true,
        ));
      } catch (e) {
        emit(LocationError("Failed to start live tracking: $e"));
      }
    });

    on<StopLiveTrackingEvent>((event, emit) async {
      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription = null;
      
      if (state is LocationLoaded) {
        final currentState = state as LocationLoaded;
        emit(LocationLoaded(
          currentState.position,
          isLiveTracking: false,
          hasPermission: currentState.hasPermission,
        ));
      }
    });

    on<UpdateLiveLocationEvent>((event, emit) {
      if (state is LocationLoaded) {
        final currentState = state as LocationLoaded;
        if (currentState.isLiveTracking) {
          emit(LocationLoaded(
            event.position,
            isLiveTracking: true,
            hasPermission: currentState.hasPermission,
          ));
        }
      }
    });
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }
}

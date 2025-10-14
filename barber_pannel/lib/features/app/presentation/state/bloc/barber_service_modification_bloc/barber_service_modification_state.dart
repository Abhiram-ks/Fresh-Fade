part of 'barber_service_modification_bloc.dart';

@immutable
abstract class BarberServiceModificationState {}

final class BarberServiceModificationInitial extends BarberServiceModificationState {}

//! delete service alert
final class BarberServiceModificationDeleteAlert extends 
BarberServiceModificationState {
  final String serviceName;

  BarberServiceModificationDeleteAlert({required this.serviceName});
}

//! update service alert
final class BarberServiceModificationUpdateAlert extends BarberServiceModificationState {
  final String serviceName;
  final String serviceRate;
  final String oldServiceRate;

  BarberServiceModificationUpdateAlert({required this.serviceName, required this.oldServiceRate, required this.serviceRate});
}

final class BarberServiceModificationLoading extends BarberServiceModificationState {}

final class BarberServiceModificationLoaded extends BarberServiceModificationState {
  final String message;

  BarberServiceModificationLoaded({required this.message});
}

final class BarberServiceModificationError extends BarberServiceModificationState {
  final String message;

  BarberServiceModificationError({required this.message});
}
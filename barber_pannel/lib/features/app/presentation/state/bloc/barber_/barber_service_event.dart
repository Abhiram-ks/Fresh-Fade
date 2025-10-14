part of 'barber_service_bloc.dart';

@immutable
abstract class BarberServiceEvent {}

final class AddBarberServiceEvent extends BarberServiceEvent {
  final String serviceName;
  final double serviceRate;

  AddBarberServiceEvent({required this.serviceName, required this.serviceRate});
}

final class BarberServiceConfirmationEvent extends BarberServiceEvent {
}
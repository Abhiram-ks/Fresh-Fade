part of 'fetch_barber_service_bloc.dart';

@immutable
abstract class FetchBarberServiceEvent {}

final class FetchBarberServiceRequest extends FetchBarberServiceEvent {
  final String barberId;

  FetchBarberServiceRequest({required this.barberId});
}
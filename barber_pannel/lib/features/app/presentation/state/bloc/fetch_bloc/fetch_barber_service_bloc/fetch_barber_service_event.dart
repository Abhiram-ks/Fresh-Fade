part of 'fetch_barber_service_bloc.dart';

@immutable
abstract class FetchBarberServiceEvent {}
final class FetchBarberServiceRequestEvent extends FetchBarberServiceEvent {}
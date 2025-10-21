part of 'fetch_barber_service_bloc.dart';

@immutable
abstract class FetchBarberServiceState {}

final class FetchBarberServiceInitial extends FetchBarberServiceState {}

final class FetchBarberServiceLoading extends FetchBarberServiceState {}

final class FetchBarberServiceEmpty extends FetchBarberServiceState {}

final class FetchBarberServiceSuccess extends FetchBarberServiceState {
  final List<BarberServiceEntity> services;
  FetchBarberServiceSuccess({required this.services});
}

final class FetchBarberServiceFailure extends FetchBarberServiceState {
  final String error;
  FetchBarberServiceFailure({required this.error});
}
part of 'fetch_barber_service_bloc.dart';

@immutable
abstract class FetchBarberServiceState {}

final class FetchBarberServiceInitial extends FetchBarberServiceState {}

final class FetchBarberServiceLoading extends FetchBarberServiceState {}

final class FetchBarberServiceEmpty extends FetchBarberServiceState {}

final class FetchBarberServiceLoaded extends FetchBarberServiceState {
  final List<BarberServiceEntity> services;

  FetchBarberServiceLoaded({required this.services});
}

final class FetchBarberServiceError extends FetchBarberServiceState {
  final String message;

  FetchBarberServiceError({required this.message});
}


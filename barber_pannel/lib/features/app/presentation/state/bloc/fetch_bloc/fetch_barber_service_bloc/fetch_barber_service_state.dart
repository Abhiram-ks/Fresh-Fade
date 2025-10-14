part of 'fetch_barber_service_bloc.dart';

@immutable
abstract class FetchBarberServiceState {}

final class FetchBarberServiceInitial extends FetchBarberServiceState {}

final class FetchBarberServiceLoading extends FetchBarberServiceState {}

final class FetchBarberServiceLoaded extends FetchBarberServiceState {
  final List<BarberServiceEntity> barberServices;

  FetchBarberServiceLoaded({required this.barberServices});
}

final class FetchBarberServiceFailure extends FetchBarberServiceState {
  final String message;

  FetchBarberServiceFailure({required this.message});
}
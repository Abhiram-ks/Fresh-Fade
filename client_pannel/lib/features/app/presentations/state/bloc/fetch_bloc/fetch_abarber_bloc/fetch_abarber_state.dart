part of 'fetch_abarber_bloc.dart';

@immutable
abstract class FetchAbarberState {}

final class FetchAbarberInitial extends FetchAbarberState {}
final class FetchAbarberLoading extends FetchAbarberState {}

final class FetchABarberSuccess extends FetchAbarberState {
  final BarberEntity barber;

  FetchABarberSuccess({required this.barber});
}

final class FetchABarberError extends FetchAbarberState {
  final String message;

  FetchABarberError({required this.message});
}
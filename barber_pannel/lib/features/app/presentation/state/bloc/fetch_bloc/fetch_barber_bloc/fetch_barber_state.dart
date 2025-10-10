part of 'fetch_barber_bloc.dart';

@immutable
abstract class FetchBarberState {}

final class FetchBarberInitial extends FetchBarberState {}
final class FetchBarberLoading extends FetchBarberState{}
final class FetchBarberLoaded extends FetchBarberState{
  final BarberEntity barber;
  FetchBarberLoaded({required this.barber});
}

final class FetchBarberError extends FetchBarberState {
  final String message;
  FetchBarberError(this.message);
}

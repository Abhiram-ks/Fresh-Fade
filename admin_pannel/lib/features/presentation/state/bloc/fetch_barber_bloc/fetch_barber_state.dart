part of 'fetch_barber_bloc.dart';

@immutable
sealed class FetchBarberState {}

final class FetchBarberInitial extends FetchBarberState {}

final class FetchBarberLoading extends FetchBarberState {}
final class FetchBarberLoaded extends FetchBarberState {
  final List<BarberEntity> barbers;
  FetchBarberLoaded(this.barbers);
}
final class FetchBarberEmpty extends FetchBarberState {}
final class FetchBarberError extends FetchBarberState {
  final String error;
  FetchBarberError(this.error);
}
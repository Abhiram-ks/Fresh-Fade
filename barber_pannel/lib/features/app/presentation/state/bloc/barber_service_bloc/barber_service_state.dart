part of 'barber_service_bloc.dart';

@immutable
abstract class BarberServiceState {}

final class BarberServiceInitial extends BarberServiceState {}


final class BarberServiceConfirmationAlertState extends BarberServiceState {
  final String text;
  final double amount;
  BarberServiceConfirmationAlertState(this.text, this.amount);
}

final class BarberServiceLoading extends BarberServiceState {}

final class BarberServiceSuccess extends BarberServiceState {}

final class BarberServiceFailure extends BarberServiceState {
  final String message;

  BarberServiceFailure(this.message);
}

part of 'fetch_booking_with_barber_bloc.dart';

@immutable
abstract class FetchBookingWithBarberEvent {}

final class FetchBookingWithBarberRequest extends FetchBookingWithBarberEvent {}

final class FetchBookingWithBarberFilter extends FetchBookingWithBarberEvent {
  final String filter;

  FetchBookingWithBarberFilter({required this.filter});
}
part of 'fetch_booking_with_barber_bloc.dart';

@immutable
abstract class FetchBookingWithBarberState {}

final class FetchBookingWithBarberInitial extends FetchBookingWithBarberState {}

final class FetchBookingWithBarberLoading extends FetchBookingWithBarberState {}

final class FetchBookingWithBarberEmpty extends FetchBookingWithBarberState {}

final class FetchBookingWithBarberSuccess extends FetchBookingWithBarberState {
  final List<BookingWithBarberModel> bookings;
  FetchBookingWithBarberSuccess({required this.bookings});
}

final class FetchBookingWithBarberFailure extends FetchBookingWithBarberState {
  final String error;
  FetchBookingWithBarberFailure({required this.error});
}
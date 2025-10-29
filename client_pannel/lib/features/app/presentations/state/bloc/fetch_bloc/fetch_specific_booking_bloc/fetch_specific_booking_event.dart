part of 'fetch_specific_booking_bloc.dart';

@immutable
abstract class FetchSpecificBookingEvent {}

final class FetchSpecificBookingRequested extends FetchSpecificBookingEvent {
  final String bookingId;
  FetchSpecificBookingRequested({required this.bookingId});
}
part of 'fetch_specific_booking_bloc.dart';

@immutable
abstract class FetchSpecificBookingState {}

final class FetchSpecificBookingInitial extends FetchSpecificBookingState {}

final class FetchSpecificBookingLoading extends FetchSpecificBookingState {}

final class FetchSpecificBookingSuccess extends FetchSpecificBookingState {
  final BookingEntity booking;
  FetchSpecificBookingSuccess({required this.booking});
}

final class FetchSpecificBookingError extends FetchSpecificBookingState {
  final String error;
  FetchSpecificBookingError({required this.error});
} 
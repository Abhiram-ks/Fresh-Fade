part of 'fetch_specific_booking_bloc.dart';

@immutable
abstract class FetchSpecificBookingState {}

final class FetchSpecificBookingInitial extends FetchSpecificBookingState {}

final class FetchSpecificBookingLoading extends FetchSpecificBookingState {}

final class FetchSpecificBookingLoaded extends FetchSpecificBookingState {
  final BookingEntity booking;
  FetchSpecificBookingLoaded({required this.booking});
}

final class FetchSpecificBookingFailure extends FetchSpecificBookingState {
  final String error;
  FetchSpecificBookingFailure({required this.error});
}
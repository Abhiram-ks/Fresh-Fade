part of 'fetch_individual_user_booking_bloc.dart';

@immutable
abstract class FetchIndividualUserBookingState {}

final class FetchIndividualUserBookingInitial extends FetchIndividualUserBookingState {}

final class FetchIndividualUserBookingLoading extends FetchIndividualUserBookingState {}

final class FetchIndividualUserBookingEmpty extends FetchIndividualUserBookingState {}

final class FetchIndividualUserBookingSuccess extends FetchIndividualUserBookingState {
  final List<BookingEntity> bookings;
  FetchIndividualUserBookingSuccess({required this.bookings});
}

final class FetchIndividualUserBookingError extends FetchIndividualUserBookingState {
  final String message;
  FetchIndividualUserBookingError({required this.message});
}
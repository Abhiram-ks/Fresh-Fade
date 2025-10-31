part of 'fetch_booking_with_user_bloc.dart';

@immutable
abstract class FetchBookingWithUserState {}

final class FetchBookingWithUserInitial extends FetchBookingWithUserState {}

final class FetchBookingWithUserLoading extends FetchBookingWithUserState {}

final class FetchBookingWithUserEmpty extends FetchBookingWithUserState {}

final class FetchBookingWithUserSuccess extends FetchBookingWithUserState {
  final List<BookingWithUserModel> bookings;

  FetchBookingWithUserSuccess({required this.bookings});
}

final class FetchBookingWithUserError extends FetchBookingWithUserState {
  final String message;
  FetchBookingWithUserError({required this.message});
}
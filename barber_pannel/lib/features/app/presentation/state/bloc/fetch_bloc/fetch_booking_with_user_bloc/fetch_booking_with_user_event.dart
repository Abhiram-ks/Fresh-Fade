part of 'fetch_booking_with_user_bloc.dart';

@immutable
abstract class FetchBookingWithUserEvent {}

final class FetchBookingWithUserRequested extends FetchBookingWithUserEvent {}

final class FetchBookingWithUserCancelled extends FetchBookingWithUserEvent {
  final String message;

  FetchBookingWithUserCancelled({required this.message});
}
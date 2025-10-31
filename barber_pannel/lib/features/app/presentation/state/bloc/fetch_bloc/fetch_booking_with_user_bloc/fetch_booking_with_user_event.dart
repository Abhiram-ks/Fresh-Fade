part of 'fetch_booking_with_user_bloc.dart';

@immutable
abstract class FetchBookingWithUserEvent {}

final class FetchBookingWithUserRequested extends FetchBookingWithUserEvent {}

final class FetchBookingWithUserFilteredRequested extends FetchBookingWithUserEvent { 
  final String status;

  FetchBookingWithUserFilteredRequested({required this.status});
}
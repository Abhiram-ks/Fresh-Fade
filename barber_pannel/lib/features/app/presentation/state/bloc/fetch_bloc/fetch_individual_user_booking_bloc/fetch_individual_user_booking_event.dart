part of 'fetch_individual_user_booking_bloc.dart';

@immutable
abstract class FetchIndividualUserBookingEvent {}

final class FetchIndividualUserBookingRequested extends FetchIndividualUserBookingEvent {
  final String userId;
  FetchIndividualUserBookingRequested({required this.userId});
}

final class FetchIndividualUserBookingFiltered extends FetchIndividualUserBookingEvent {
  final String userId;
  final String status;
  FetchIndividualUserBookingFiltered({required this.userId, required this.status});
}
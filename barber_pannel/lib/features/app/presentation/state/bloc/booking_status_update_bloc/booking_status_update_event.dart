part of 'booking_status_update_bloc.dart';

@immutable
abstract class BookingStatusUpdateEvent {}

final class BookingStatusUpdateRequested extends BookingStatusUpdateEvent {
  final String docId;
  final String barberId;
  final bool isAll;
  BookingStatusUpdateRequested({required this.docId, required this.barberId, required this.isAll});
}

final class BookingStatusUpdateConfirmed extends BookingStatusUpdateEvent {

}

final class BookingStatusUpdatesAllTimeouts extends BookingStatusUpdateEvent {

}
part of 'booking_status_update_bloc.dart';

@immutable
abstract class BookingStatusUpdateState {}

final class BookingStatusUpdateInitial extends BookingStatusUpdateState {}

final class BookingStatusUpdateAlertBox extends BookingStatusUpdateState {
  final bool isAll;
  BookingStatusUpdateAlertBox({required this.isAll});
}


final class BookingStatusUpdateLoading extends BookingStatusUpdateState {}

final class BookingStatusUpdateSuccess extends BookingStatusUpdateState {}

final class BookingStatusUpdateFailure extends BookingStatusUpdateState {
  final String error;
  BookingStatusUpdateFailure({required this.error});
}
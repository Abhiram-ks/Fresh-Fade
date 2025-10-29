part of 'cancel_booking_bloc.dart';

@immutable
abstract class CancelBookingEvent {}

final class BookingOTPChecking extends CancelBookingEvent {
  final String bookingOTP;
  final String inputOTP;
  BookingOTPChecking({required this.bookingOTP, required this.inputOTP});
}

final class BookingCancelOTPChecked extends CancelBookingEvent {
  final BookingEntity booking;
  BookingCancelOTPChecked({required this.booking});
}
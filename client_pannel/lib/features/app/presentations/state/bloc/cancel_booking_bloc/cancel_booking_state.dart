part of 'cancel_booking_bloc.dart';

@immutable
abstract class CancelBookingState {}

final class CancelBookingInitial extends CancelBookingState {}

final class BookingOTPMachingLoading extends CancelBookingState {}  

final class BookingOTPMachingTrue extends CancelBookingState {}

final class BookingOTPMachingfalse extends CancelBookingState {}

final class BookingCancelCompleted extends CancelBookingState {}


final class BookingOTPMachingFailure extends CancelBookingState {
  final String error;
  BookingOTPMachingFailure({required this.error});
}
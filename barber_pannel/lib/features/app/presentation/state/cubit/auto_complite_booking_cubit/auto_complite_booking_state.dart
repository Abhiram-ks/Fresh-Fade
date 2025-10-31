part of 'auto_complite_booking_cubit.dart';

@immutable
abstract class AutoComplitedBookingState {}

final class AutoComplitedBookingInitial extends AutoComplitedBookingState {}
final class AutoComplitedBookingSuccess extends AutoComplitedBookingState {}
final class AutoComplitedBookingFailure extends AutoComplitedBookingState {}

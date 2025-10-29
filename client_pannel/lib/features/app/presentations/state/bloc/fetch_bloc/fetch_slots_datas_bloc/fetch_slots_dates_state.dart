part of 'fetch_slots_dates_bloc.dart';

@immutable
abstract class FetchSlotsDatesState {}

final class FetchSlotsDatesInitial extends FetchSlotsDatesState {}
final class FetchSlotsDatesLoading extends FetchSlotsDatesState {}

final class FetchSlotsDatesSuccess extends FetchSlotsDatesState {
  final List<DateModel> dates;
  FetchSlotsDatesSuccess({required this.dates});
}

final class FetchSlotsDatesFailure extends FetchSlotsDatesState {
  final String error;
  FetchSlotsDatesFailure({required this.error});
}
part of 'fetch_slots_specific_date_bloc.dart';

@immutable
abstract class FetchSlotsSpecificDateState {}

final class FetchSlotsSpecificDateInitial extends FetchSlotsSpecificDateState {}

final class FetchSlotsSpecificDateLoading extends FetchSlotsSpecificDateState {}

final class FetchSlotsSpecificDateEmpty extends FetchSlotsSpecificDateState {
  final DateTime selectedDate;
  FetchSlotsSpecificDateEmpty({required this.selectedDate});
}

final class FetchSlotsSpecificDateSuccess extends FetchSlotsSpecificDateState {
  final List<SlotModel> slots;
  FetchSlotsSpecificDateSuccess({required this.slots});
}

final class FetchSlotsSpecificDateFailure extends FetchSlotsSpecificDateState {
  final String error;
  FetchSlotsSpecificDateFailure({required this.error});
}

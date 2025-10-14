part of 'fetch_slot_specific_data_bloc.dart';

@immutable
abstract class FetchSlotsSpecificdateEvent {}

final class FetchSlotsSpecificdateRequst extends FetchSlotsSpecificdateEvent {
  final DateTime selectedDate;

   FetchSlotsSpecificdateRequst(this.selectedDate);
}

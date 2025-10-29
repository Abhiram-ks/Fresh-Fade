part of 'fetch_slots_specific_date_bloc.dart';

@immutable
abstract class FetchSlotsSpecificDateEvent {}

final class FetchSlotSpecificDateRequested extends FetchSlotsSpecificDateEvent {
  final DateTime selectedDate;
  final String barberId;
  
  FetchSlotSpecificDateRequested({required this.selectedDate, required this.barberId});
}
part of 'fetch_slots_dates_bloc.dart';

@immutable
abstract class FetchSlotsDatesEvent {}

final class FetchSlotsDatesRequested extends FetchSlotsDatesEvent {
  final String barberId;

  FetchSlotsDatesRequested({required this.barberId});
}
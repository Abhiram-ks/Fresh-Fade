part of 'fetch_barber_bloc_bloc.dart';

@immutable
abstract class FetchAllbarberEvent {}
class FetchAllBarbersRequested extends FetchAllbarberEvent {}
class SearchBarbersRequested extends FetchAllbarberEvent {
  final String searchTerm;

  SearchBarbersRequested(this.searchTerm);
}

class FilterBarbersRequested extends FetchAllbarberEvent {
  final Set<String> selectServices;
  final double rating;
  final String? gender;

  FilterBarbersRequested({
    required this.selectServices,
    required this.rating,
    required this.gender,
  });
}

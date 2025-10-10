part of 'fetch_barber_bloc.dart';

@immutable
sealed class FetchBarberEvent {}

final class FetchAllBarbersEvent extends FetchBarberEvent {}

part of 'fetch_abarber_bloc.dart';

@immutable
abstract class FetchAbarberEvent {}

final class FetchABarberEventRequest extends FetchAbarberEvent {
  final String barberId;

  FetchABarberEventRequest({required this.barberId});
}
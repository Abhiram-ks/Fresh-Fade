part of 'fetch_barber_post_bloc.dart';

@immutable
abstract class FetchBarberPostEvent {}

final class FetchBarberPostRequest extends FetchBarberPostEvent {
  final String barberId;

  FetchBarberPostRequest({required this.barberId});
}
part of 'fech_post_with_barber_bloc.dart';

@immutable
abstract class FechPostWithBarberState {}

final class FechPostWithBarberInitial extends FechPostWithBarberState {}

final class FetchPostWithBarberLoading extends FechPostWithBarberState {}

final class FetchPostWithBarberEmpty extends FechPostWithBarberState {}

final class FetchPostWithBarberLoaded extends FechPostWithBarberState {
  final List<PostWithBarberModel> posts;
  final String userId;
  FetchPostWithBarberLoaded({required this.posts, required this.userId});
}

final class FetchPostWithBarberFailure extends FechPostWithBarberState {
  final String error;
  FetchPostWithBarberFailure({required this.error});
}
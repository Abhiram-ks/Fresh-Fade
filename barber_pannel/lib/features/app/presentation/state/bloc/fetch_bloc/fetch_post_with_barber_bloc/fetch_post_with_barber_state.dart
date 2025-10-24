part of 'fetch_post_with_barber_bloc.dart';

@immutable
abstract class FetchPostWithBarberState {}

final class FetchPostWithBarberInitial extends FetchPostWithBarberState {}
final class FetchPostWithBarberLoading extends FetchPostWithBarberState {}

final class FetchPostWithBarberEmpty extends FetchPostWithBarberState {}

final class FetchPostWithBarberLoaded extends FetchPostWithBarberState {
  final List<PostWithBarberModel> posts;
  FetchPostWithBarberLoaded({required this.posts});
}

final class FetchPostWithBarberError extends FetchPostWithBarberState {
  final String message;
  FetchPostWithBarberError({required this.message});
}
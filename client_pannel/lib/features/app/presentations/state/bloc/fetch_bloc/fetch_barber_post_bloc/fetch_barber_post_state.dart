part of 'fetch_barber_post_bloc.dart';

@immutable
abstract class FetchBarberPostState {}

final class FetchBarberPostInitial extends FetchBarberPostState {}

final class FetchBarberPostLoading extends FetchBarberPostState {}

final class FetchBarberPostEmpty extends FetchBarberPostState {}

final class FetchBarberPostSuccess extends FetchBarberPostState {
  final List<PostEntity> posts;

  FetchBarberPostSuccess({required this.posts});
}

final class FetchBarberPostFailure extends FetchBarberPostState {
  final String error;
  FetchBarberPostFailure({required this.error});
}
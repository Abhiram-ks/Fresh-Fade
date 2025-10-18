part of 'fetch_user_bloc.dart';

@immutable
abstract class FetchUserState {}

final class FetchUserInitial extends FetchUserState {}

final class FetchUserLoading extends FetchUserState {}

final class FetchUserLoaded extends FetchUserState {
  final UserEntity user;
  FetchUserLoaded({required this.user});
}

final class FetchUserFailure extends FetchUserState {
  final String error;
  FetchUserFailure({required this.error});
}
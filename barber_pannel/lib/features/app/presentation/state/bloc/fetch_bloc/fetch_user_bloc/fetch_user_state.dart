part of 'fetch_user_bloc.dart';

@immutable
abstract class FetchUserState {}

final class FetchUserInitial extends FetchUserState {}

final class FetchUserLoading extends FetchUserState {}

final class FetchUserLoaded extends FetchUserState {
  final UserEntity user;
  final String barberId;
  FetchUserLoaded({required this.user, required this.barberId});
}

final class FetchUserError extends FetchUserState {
  final String message;
  FetchUserError({required this.message});
}
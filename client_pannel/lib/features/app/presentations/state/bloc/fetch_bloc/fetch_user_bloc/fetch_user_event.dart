part of 'fetch_user_bloc.dart';

@immutable
sealed class FetchUserEvent {}

final class FetchUserStarted extends FetchUserEvent {}

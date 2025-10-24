part of 'fetch_chat_user_lebel_bloc.dart';

@immutable
abstract class FetchChatUserlebelState {}

final class FetchChatUserlebelInitial extends FetchChatUserlebelState {}
final class FetchChatUserlebelLoading extends FetchChatUserlebelState {}
final class FetchChatUserlebelEmpty extends FetchChatUserlebelState {}
final class FetchChatUserlebelSuccess extends FetchChatUserlebelState {
  final List<UserEntity> users;
  final String barberId;

  FetchChatUserlebelSuccess({required this.users, required this.barberId});
}
final class FetchChatUserlebelFailure  extends FetchChatUserlebelState {}

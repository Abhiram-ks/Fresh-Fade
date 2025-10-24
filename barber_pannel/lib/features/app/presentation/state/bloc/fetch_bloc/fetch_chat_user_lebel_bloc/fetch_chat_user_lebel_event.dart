part of 'fetch_chat_user_lebel_bloc.dart';

@immutable
abstract class FetchChatUserlebelEvent {}
final class FetchChatLebelUserRequst extends FetchChatUserlebelEvent{}
final class FetchChatLebelUserSearch extends FetchChatUserlebelEvent{
  final String searchController;

  FetchChatLebelUserSearch(this.searchController);
}
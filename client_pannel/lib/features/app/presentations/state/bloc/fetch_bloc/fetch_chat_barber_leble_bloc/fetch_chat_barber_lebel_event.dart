part of 'fetch_chat_barber_lebel_bloc.dart';

@immutable
abstract class FetchChatBarberlebelEvent {}

final class FetchChatLebelBarberRequst extends FetchChatBarberlebelEvent{}

final class FetchChatLebelBarberSearch extends FetchChatBarberlebelEvent{
  final String searchController;

  FetchChatLebelBarberSearch(this.searchController);
}
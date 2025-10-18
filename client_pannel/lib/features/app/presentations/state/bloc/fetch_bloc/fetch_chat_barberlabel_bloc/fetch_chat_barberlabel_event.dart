part of 'fetch_chat_barberlabel_bloc.dart';

@immutable
abstract class FetchChatBarberlabelEvent {}

final class FetchChatLebelBarberRequst extends FetchChatBarberlabelEvent {}

final class FetchChatLebelBarberSearch extends FetchChatBarberlabelEvent {
  final String query;

  FetchChatLebelBarberSearch({required this.query});
}
part of 'fetch_chat_barberlabel_bloc.dart';

@immutable
abstract class FetchChatBarberlabelState {}

final class FetchChatBarberlabelInitial extends FetchChatBarberlabelState {}

final class FetchChatBarberlebelLoading extends FetchChatBarberlabelState {}

final class FetchChatBarberlebelEmpty extends FetchChatBarberlabelState {}

final class FetchChatBarberlebelSuccess extends FetchChatBarberlabelState {
  final List<BarberEntity> barbers;
  final String userID;

  FetchChatBarberlebelSuccess({required this.barbers, required this.userID});
}

final class FetchChatBarberlebelFailure extends FetchChatBarberlabelState {
  final String error;

  FetchChatBarberlebelFailure({required this.error});
}
part of 'fetch_user_bloc.dart';

@immutable
abstract class FetchUserEvent {}

final class FetchUserRequest extends FetchUserEvent {
  final String userId;
  FetchUserRequest({required this.userId});
}
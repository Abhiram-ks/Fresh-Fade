part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

final class LoginActionEvent extends LoginEvent {
  final String email;
  final String password;

  LoginActionEvent({required this.email, required this.password});
}
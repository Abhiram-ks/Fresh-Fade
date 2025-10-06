part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}
final class LoginRequest extends LoginEvent {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
}
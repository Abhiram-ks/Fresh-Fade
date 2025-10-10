part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}
final class LoginNotVerified extends LoginState {}

final class LoginEmailNotVarify extends LoginState {
  final String email;
  LoginEmailNotVarify({required this.email});
}
final class LoginBlocShop extends LoginState {}
final class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});
}
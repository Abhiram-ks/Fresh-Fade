part of 'password_bloc.dart';

@immutable
abstract class PasswordState {}

final class PasswordInitial extends PasswordState {}

final class PasswordAlertBoxState extends PasswordState {
  final String email;
  PasswordAlertBoxState({required this.email});
}

final class PasswordLoadingState extends PasswordState {}

final class PasswordSuccessState extends PasswordState {}

final class PasswordErrorState extends PasswordState {
  final String message;
  PasswordErrorState({required this.message});
}

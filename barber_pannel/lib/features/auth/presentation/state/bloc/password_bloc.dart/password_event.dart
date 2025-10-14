part of 'password_bloc.dart';

@immutable
abstract class PasswordEvent {}

final class PasswordRequestedEvent extends PasswordEvent {
  final String email;
  PasswordRequestedEvent({required this.email});
}

final class PasswordConfirmationEvent extends PasswordEvent {}

part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthSignInWithGoogleEvent extends AuthEvent {}
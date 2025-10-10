part of 'logout_bloc.dart';

@immutable
abstract class LogoutEvent {}

final class LogoutRequestEvent extends LogoutEvent {}

final class LogoutConfirmEvent extends LogoutEvent {}

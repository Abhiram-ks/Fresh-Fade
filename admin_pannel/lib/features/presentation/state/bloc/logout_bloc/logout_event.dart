part of 'logout_bloc.dart';

@immutable
abstract class LogoutEvent  {}
class LogoutActionEvent extends LogoutEvent {}
class ConfirmLogoutEvent extends LogoutEvent {}

part of 'launcher_service_bloc.dart';

@immutable
abstract class LauncherServiceEvent {}

final class LauncherServiceAlertEvent extends LauncherServiceEvent {
  final String name;
  final String email;
  final String subject;
  final String body;

  LauncherServiceAlertEvent({required this.name, required this.email, required this.subject, required this.body});
}

final class LauncherServiceConfirmEvent extends LauncherServiceEvent {}

part of 'lauch_service_bloc.dart';

@immutable
abstract class LauchServiceEvent {}

final class LauchServiceAlertBoxEvent extends LauchServiceEvent {
  final String name;
  final String email;
  final String subject;
  final String body;

  LauchServiceAlertBoxEvent({required this.name, required this.email, required this.subject, required this.body});
}

final class LauchServiceConfirmEvent extends LauchServiceEvent {}
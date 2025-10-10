part of 'request_bloc.dart';

@immutable
abstract class RequestEvent {}


//! isAccept event
final class AcceptAction extends RequestEvent {
  final String name;
  final String ventureName;
  final String id;

  AcceptAction({required this.name, required this.ventureName, required this.id});
}

final class AcceptConfirmation extends RequestEvent {}

//! isReject event
final class RejectAction extends RequestEvent {
  final String name;
  final String ventureName;
  final String id;

  RejectAction({required this.name, required this.ventureName, required this.id});
}

final class RejectConfirmation extends RequestEvent {
  final String reason;

  RejectConfirmation({required this.reason});
}

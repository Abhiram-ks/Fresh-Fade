part of 'request_bloc.dart';

@immutable
abstract class RequestState {}
final class RequestInitial extends RequestState {}


//! isAccept
final class AcceptAlertState extends RequestState {
  final String name;
  final String ventureName;

  AcceptAlertState({required this.name, required this.ventureName});
}

//! isReject
final class RejectAlertState extends RequestState {
  final String name;
  final String ventureName;

  RejectAlertState({required this.name, required this.ventureName});
}

//! Accept/ Reject States
final class RequestSuccessState extends RequestState {}
final class RequestErrorState extends RequestState {
  final String error;
  RequestErrorState({required this.error});
}
part of 'fetch_service_bloc.dart';

@immutable
sealed class FetchServiceEvent {}
class FetchServiceDataEvent extends FetchServiceEvent{}

part of 'fetch_service_bloc.dart';

@immutable
abstract class FetchServiceEvent {}
final class FetchServiceRequest extends FetchServiceEvent {}
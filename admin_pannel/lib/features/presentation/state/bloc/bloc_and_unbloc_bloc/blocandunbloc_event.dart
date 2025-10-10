part of 'blocandunbloc_bloc.dart';

@immutable
abstract class BlocandunblocEvent {}

final class ShowBlocAlertEvent extends BlocandunblocEvent {
  final String uid;
  final String name;
  final String ventureName;

  ShowBlocAlertEvent({required this.name, required this.ventureName, required this.uid});
}

final class BlocConfirmationEvent extends BlocandunblocEvent {}

final class ShowUnBlacAlertEvent extends BlocandunblocEvent{
  final String uid;
  final String name;
  final String ventureName;

  ShowUnBlacAlertEvent({required this.name, required this.uid, required this.ventureName});
}

final class UnBlocConfirmationEvent extends BlocandunblocEvent {}




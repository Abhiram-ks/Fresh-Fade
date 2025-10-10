part of 'blocandunbloc_bloc.dart';

@immutable
abstract class BlocandunblocState {}

final class BlocandunblocInitial extends BlocandunblocState {}

final class BlocShowBlocAlertState extends BlocandunblocState {
  final String name;
  final String ventureName;

  BlocShowBlocAlertState({required this.name, required this.ventureName});
}

final class BlocShowUnblocAlertState extends BlocandunblocState {
  final String name;
  final String ventureName;

  BlocShowUnblocAlertState({required this.name, required this.ventureName});
}

final class BlocSuccessState extends BlocandunblocState {}

final class BlocErrorState extends BlocandunblocState {
  final String error;

  BlocErrorState({required this.error});
}


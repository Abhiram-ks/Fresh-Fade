part of 'delete_account_bloc.dart';

@immutable
abstract class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}

final class DeleteAccountAlertBox extends DeleteAccountState {}

final class DeleteAccountLoading extends DeleteAccountState {}
final class DeleteAccountSuccess extends DeleteAccountState {}
final class DeleteAccountFailure extends DeleteAccountState {
  final String error;
  DeleteAccountFailure({required this.error});
}
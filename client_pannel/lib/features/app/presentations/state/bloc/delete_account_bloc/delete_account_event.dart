part of 'delete_account_bloc.dart';

@immutable
abstract class DeleteAccountEvent {}

final class DeleteAccountAlertBoxEvent extends DeleteAccountEvent {}
final class DeleteAccountConfirmEvent extends DeleteAccountEvent {}
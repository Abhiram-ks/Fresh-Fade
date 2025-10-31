part of 'fetch_wallet_bloc.dart';

@immutable
abstract class FetchWalletState {}

final class FetchWalletInitial extends FetchWalletState {}

final class FetchWalletLoading extends FetchWalletState {}

final class FetchWalletLoaded extends FetchWalletState {
  final double amount;
  FetchWalletLoaded({required this.amount});
}

final class FetchWalletError extends FetchWalletState {
  final String message;
  FetchWalletError({required this.message});
}
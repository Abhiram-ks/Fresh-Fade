part of 'fetch_wallet_bloc.dart';

@immutable
abstract class FetchWalletEvent {}

final class FetchWalletEventStarted extends FetchWalletEvent {}


import 'package:barber_pannel/features/app/domain/usecase/booking_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'fetch_wallet_event.dart';
part 'fetch_wallet_state.dart';

class FetchWalletBloc extends Bloc<FetchWalletEvent, FetchWalletState> {
  final BookingUsecase repo;
  final AuthLocalDatasource localDB;

  FetchWalletBloc({required this.repo, required this.localDB}) : super(FetchWalletInitial()) {
    on<FetchWalletEventStarted>((event, emit) async {
      emit(FetchWalletLoading());
      try {
        final String? barberId = await localDB.get();
        if (barberId == null || barberId.isEmpty) {
          emit(FetchWalletError(message: 'Token expired. Please login again.'));
          return;
        }
        await emit.forEach<double>(
          repo.calculateTotalAmount(barberId: barberId),
          onData: (amount) {
            return FetchWalletLoaded(amount: amount.toDouble());
          },
          onError: (error, __) {
            return FetchWalletError(message: error.toString());
          },
        );
      } catch (e) {
        emit(FetchWalletError(message: e.toString()));
      }
    });
  }
}


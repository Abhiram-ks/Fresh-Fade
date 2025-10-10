import 'package:barber_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'fetch_barber_event.dart';
part 'fetch_barber_state.dart';

class FetchBarberBloc extends Bloc<FetchBarberEvent, FetchBarberState> {
  final AuthLocalDatasource localDB;
  final GetBarberUseCase useCase;

  FetchBarberBloc({
    required this.localDB,
    required this.useCase,
  }) : super(FetchBarberInitial()) {
    on<FetchBarberRequest>(_onFetchBarber);
  }

  Future<void> _onFetchBarber(
    FetchBarberRequest event,
    Emitter<FetchBarberState> emit,
  ) async {
    emit(FetchBarberLoading());

    try {
      final barberId = await localDB.get();
      
      if (barberId != null && barberId.isNotEmpty) {
        await emit.forEach<BarberEntity>(
          useCase(barberId),
          onData: (barber) {
            return FetchBarberLoaded(barber: barber);
          },
          onError: (error, stackTrace) {
            return FetchBarberError('Failed to fetch barber data: $error');
          },
        );
      } else {
        emit(FetchBarberError('Barber ID not found. Please login again.'));
      }
    } catch (e) {
      emit(FetchBarberError('Unexpected error: $e'));
    }
  }
}

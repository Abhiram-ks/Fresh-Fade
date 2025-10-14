import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/datasource/slot_remote_datasource.dart';
import '../../../../../data/model/date_model.dart';

part 'fetch_slot_dates_event.dart';
part 'fetch_slot_dates_state.dart';

class FetchSlotsDatesBloc extends Bloc<FetchSlotsDatesEvent, FetchSlotsDatesState> {
  final FetchSlotsRepository fetchSlotsRepository;
  final AuthLocalDatasource localDB;

  FetchSlotsDatesBloc({required this.fetchSlotsRepository, required this.localDB}) : super(FetchSlotsDatesInitial()) {
    on<FetchSlotsDateRequest>(_onFetchSlotsDatesRequest);
  }

Future<void> _onFetchSlotsDatesRequest(
   FetchSlotsDateRequest event, Emitter<FetchSlotsDatesState> emit) async {
   emit(FetchSlotsDateLoading());
   try {
     final String? barberUid = await localDB.get();

     if (barberUid == null) {
       emit(FetchSlotsDateFailure('Token expired please login again'));
       return;
     }

     await fetchSlotsRepository.streamDates(barberUid).forEach((dates) {
       emit(FetchSlotsDatesSuccess(dates));
     });
   } catch (e) {
     emit(FetchSlotsDateFailure('An error occurred'));
   }
 }


}

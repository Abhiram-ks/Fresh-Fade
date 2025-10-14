import 'package:barber_pannel/features/app/data/datasource/slot_remote_datasource.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/model/slot_model.dart';

part 'fetch_slot_specific_data_event.dart';
part 'fetch_slot_specific_data_state.dart';

class FetchSlotsSpecificdateBloc extends Bloc<FetchSlotsSpecificdateEvent, FetchSlotsSpecificDateState> {
  final FetchSlotsRepository _fetchSlotsRepository;
  final AuthLocalDatasource localDB;
  
  FetchSlotsSpecificdateBloc(this._fetchSlotsRepository, this.localDB) : super(FetchSlotsSpecificDateInitial()) {
    on<FetchSlotsSpecificdateRequst>(_onFetchSlotsSpecificDateRequest);
  }

  Future<void> _onFetchSlotsSpecificDateRequest(
    FetchSlotsSpecificdateRequst event,
    Emitter<FetchSlotsSpecificDateState> emit,
  ) async {
    emit(FetchSlotsSpecificDateLoading());
    try {
      final String? barberUid = await localDB.get();

      if (barberUid == null || barberUid.isEmpty) {
        emit(FetchSlotsSpecificDateFailure('Token expired. Please login again.'));
        return;
      }

      await emit.forEach<List<SlotModel>>(
        _fetchSlotsRepository.streamSlots(
          barberUid: barberUid,
          selectedDate: event.selectedDate,
        ),
        onData: (slots) {
          if (slots.isEmpty) {
            return FetchSlotsSpecificDateEmpty(event.selectedDate);
          } else {
            return FetchSlotsSpecificDateLoaded(slots: slots);
          }
        },
        onError: (error, stackTrace) {
          return FetchSlotsSpecificDateFailure(error.toString());
        },
      );

    } catch (e) {
      emit(FetchSlotsSpecificDateFailure(e.toString()));
    }
  }
}

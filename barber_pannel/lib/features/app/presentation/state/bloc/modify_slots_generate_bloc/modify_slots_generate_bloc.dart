import 'package:barber_pannel/features/app/domain/repo/slot_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'modify_slots_generate_event.dart';
part 'modify_slots_generate_state.dart';
class ModifySlotsGenerateBloc extends Bloc<ModifySlotsGenerateEvent, ModifySlotsGenerateState> {
  final UpdateSlotRepository _updateSlotRepository;
  String _shopId = '';
  String _docId  = '';
  String _subDocId = '';

  ModifySlotsGenerateBloc(this._updateSlotRepository) : super(ModifySlotsInitial()) {
    on<ChangeSlotStatusEvent>(_onChangeSlotStatusEvent);
    on<RequestDeleteGeneratedSlotEvent>((event, emit) {
      _shopId   = event.shopId;
      _docId    = event.docId;
      _subDocId = event.subDocId;
      emit(ShowDeleteSlotAlert(event.time, event.docId));
    });

    on<ConfirmDeleteGeneratedSlotEvent>(_onConfirmDeleteGeneratedSlotEvent);
  }

  Future<void> _onChangeSlotStatusEvent(ChangeSlotStatusEvent event, Emitter<ModifySlotsGenerateState> emit) async {
    try {
      final bool isSuccess = await _updateSlotRepository.updateSlotAvailability(shopId: event.shopId, docId: event.docId, subDocId: event.subDocId, status: event.status);
       
      if (!isSuccess) {
       emit(SlotStatusChangeFailure('Unexpected error occurred.', event.docId));
      }
    } catch (e) {
      emit(SlotStatusChangeFailure(e.toString(), event.docId));
    }
  }


  Future<void> _onConfirmDeleteGeneratedSlotEvent(ConfirmDeleteGeneratedSlotEvent event, Emitter<ModifySlotsGenerateState> emit) async {
    emit(DeleteSlotLoading());
    try {
      final bool isSuccess = await _updateSlotRepository.deleteSlotsFunction(shopId: _shopId, docId: _docId, subDocId: _subDocId);
      if (isSuccess) {
        emit(DeleteSlotSuccess());
      }else{
        emit(DeleteSlotFailure('Unexpected error occurred.'));
      }
    } catch (e) {
      emit(DeleteSlotFailure(e.toString()));
    }
  }
}

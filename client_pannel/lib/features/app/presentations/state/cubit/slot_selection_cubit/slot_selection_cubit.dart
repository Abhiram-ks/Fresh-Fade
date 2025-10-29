import 'package:bloc/bloc.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
part 'slot_selection_state.dart';

class SlotSelectionCubit extends Cubit<SlotSelectionState> {
  SlotSelectionCubit() : super(SlotSelectionState());

  void toggleSlot(SlotModel slot, int maxSelectableSlots) {
   final List<SlotModel> updatedSlots = List<SlotModel>.from(state.selectedSlots);
    final int index = updatedSlots.indexWhere((s) => s.subDocId == slot.subDocId);

    if (index != -1) {
      updatedSlots.removeAt(index);
    } else {
      if (updatedSlots.length < maxSelectableSlots) {
        updatedSlots.add(slot);
      }
    }
    emit(state.copyWith(selectedSlots: updatedSlots));

  }
  
  bool isSlotSelected(String subDocId) {
    return state.selectedSlots.any((s) => s.subDocId == subDocId);
  }

  void clearSlots() {
    emit(SlotSelectionState(selectedSlots: []));
  }
}

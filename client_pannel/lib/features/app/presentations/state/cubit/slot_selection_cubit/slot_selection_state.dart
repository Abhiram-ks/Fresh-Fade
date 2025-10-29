part of 'slot_selection_cubit.dart';

class SlotSelectionState {
  final List<SlotModel> selectedSlots;

  SlotSelectionState({this.selectedSlots = const []});

  SlotSelectionState copyWith({List<SlotModel>? selectedSlots}) {
    return SlotSelectionState(selectedSlots: selectedSlots ?? this.selectedSlots);
  }
}
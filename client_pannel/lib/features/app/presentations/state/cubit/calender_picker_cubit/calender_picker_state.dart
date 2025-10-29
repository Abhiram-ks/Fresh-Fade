part of 'calender_picker_cubit.dart';

class CalenderPickerState {
  final DateTime selectedData;

  CalenderPickerState(this.selectedData);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalenderPickerState &&
        other.selectedData.year == selectedData.year &&
        other.selectedData.month == selectedData.month &&
        other.selectedData.day == selectedData.day;
  }

  @override
  int get hashCode => selectedData.hashCode;
}
import 'package:bloc/bloc.dart';
part 'calender_picker_state.dart';

class CalenderPickerCubit extends Cubit<CalenderPickerState> {
  CalenderPickerCubit() : super(CalenderPickerState(DateTime.now()));

  void selectData(DateTime date) {
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate.isBefore(currentDate)) {
      emit(CalenderPickerState(currentDate));
    } else {
      emit(CalenderPickerState(selectedDate));
    }
  }
}

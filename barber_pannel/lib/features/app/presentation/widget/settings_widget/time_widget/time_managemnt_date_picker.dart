import 'package:barber_pannel/features/app/data/model/date_model.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_dates_bloc/fetch_slot_dates_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../../service/formalt/data_time_formalt.dart';
import '../../../state/cubit/calender_picker_cubit/calender_picker_cubit.dart';

class TimeManagementDatePIcker extends StatelessWidget {
  const TimeManagementDatePIcker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalenderPickerCubit, CalenderPickerState>(
      builder: (context, state) {
        return BlocBuilder<FetchSlotsDatesBloc, FetchSlotsDatesState>(
          builder: (context, dateState) {
    
            if (dateState is FetchSlotsDatesSuccess) {
              List<DateModel> notAvailableDates = dateState.dates;
              Set<DateTime> disabledDates = getDisabledDates(notAvailableDates);
              return Column(
                children: [
                  TableCalendar(
                    focusedDay: state.selectedDate,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(
                      DateTime.now().year + 3,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(state.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!disabledDates.contains(DateTime(selectedDay.year,selectedDay.month, selectedDay.day))) {
                        context.read<CalenderPickerCubit>().updateSelectedDate(selectedDay);
                      }
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppPalette.buttonColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppPalette.buttonColor.withValues(alpha: .5),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: AppPalette.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final isDisabled = disabledDates.contains( DateTime(day.year, day.month, day.day),
                        ); if (isDisabled) {
                          return Center(
                            child: Text('${day.day}',style: TextStyle( color:AppPalette.greyColor)),
                          );
                        } return null;
                      },
                    ),
                  ), 
                  ConstantWidgets.hight10(context),
                  Text("Selected Date: ${state.selectedDate.day}/${state.selectedDate.month}/${state.selectedDate.year}",
                    style: const TextStyle( fontSize: 16,fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }
            return TableCalendar( 
              focusedDay: state.selectedDate,
              firstDay: DateTime.now(),
              lastDay: DateTime(
                      DateTime.now().year + 3,
                      DateTime.now().month,
                      DateTime.now().day),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const { CalendarFormat.month: 'Month' },
              selectedDayPredicate: (day) {return isSameDay(state.selectedDate, day);},
              onDaySelected: (selectedDay, focusedDay) {
                      context.read<CalenderPickerCubit>().updateSelectedDate(selectedDay);},
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppPalette.buttonColor,shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppPalette.buttonColor.withValues(alpha: .5),shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppPalette.whiteColor,fontWeight: FontWeight.bold,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
          },
        );
      },
    );
  }
}


bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

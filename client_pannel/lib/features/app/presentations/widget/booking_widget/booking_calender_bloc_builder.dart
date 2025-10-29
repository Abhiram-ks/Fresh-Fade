
import 'package:client_pannel/features/app/data/model/data_model.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:client_pannel/service/formalt/time_date_formalt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_slots_datas_bloc/fetch_slots_dates_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../state/bloc/fetch_bloc/fetch_slots_specific_date_bloc/fetch_slots_specific_date_bloc.dart';

class BookingCalenderBlocBuilder extends StatelessWidget {
  final String barberId;
  const BookingCalenderBlocBuilder({
    super.key,
    required this.barberId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalenderPickerCubit, CalenderPickerState>(
      builder: (context, calenderState) {
        return BlocBuilder<FetchSlotsDatesBloc, FetchSlotsDatesState>(
          builder: (context, dateState) {
            if (dateState is FetchSlotsDatesSuccess) {
              final List<DateModel> availableDates = dateState.dates;
              final Set<DateTime> enabledDates = availableDates
                  .map((dateModel) => parseDate(dateModel.date))
                  .toSet();

              return Column(
                children: [
                  TableCalendar(
                    focusedDay: calenderState.selectedData,
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
                      return isSameDay(calenderState.selectedData, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (enabledDates.contains(DateTime(selectedDay.year,
                          selectedDay.month, selectedDay.day))) {
                        context
                            .read<CalenderPickerCubit>()
                            .selectData(selectedDay);
                        context.read<FetchSlotsSpecificDateBloc>().add(
                            FetchSlotSpecificDateRequested(
                                barberId: barberId, selectedDate: selectedDay));
                      }
                    },
                    calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppPalette.orengeColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppPalette.buttonColor,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppPalette.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        defaultTextStyle:
                            TextStyle(fontWeight: FontWeight.w900)),
                    calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                      final isEnable = enabledDates
                          .contains(DateTime(day.year, day.month, day.day));

                      if (!isEnable) {
                        return Center(
                            child: Text('${day.day}',
                                style: TextStyle(color: AppPalette.greyColor)));
                      }
                      return Center(
                          child: Text('${day.day}',
                              style: TextStyle(
                                  color: AppPalette.blackColor,
                                  fontWeight: FontWeight.w900)));
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                ],
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300] ?? AppPalette.greyColor,
              highlightColor: AppPalette.whiteColor,
              child: TableCalendar(
                focusedDay: calenderState.selectedData,
                firstDay: DateTime.now(),
                lastDay: DateTime(
                  DateTime.now().year + 3,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppPalette.greyColor, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppPalette.greyColor, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        color: AppPalette.whiteColor,
                        fontWeight: FontWeight.bold),
                    defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                    outsideDaysVisible: false),
              ),
            );
          },
        );
      },
    );
  }
}

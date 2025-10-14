

import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_dates_bloc/fetch_slot_dates_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_specific_data_bloc/fetch_slot_specific_data_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../service/formalt/data_time_formalt.dart';
import '../../../../data/model/date_model.dart';


BlocBuilder<CalenderPickerCubit, CalenderPickerState> pageTwoCalenderPicker() {
    return BlocBuilder<CalenderPickerCubit, CalenderPickerState>(
      builder: (context, calenderState) {
        return BlocBuilder<FetchSlotsDatesBloc, FetchSlotsDatesState>(
          builder: (context, dateState) {
            if (dateState is FetchSlotsDatesSuccess) {
              final List<DateModel> availableDates = dateState.dates;

              final Set<DateTime> enabledDates = availableDates.map((dateModel) => parseDate(dateModel.date)).toSet();
              return Column(
                children: [
                  TableCalendar(
                    focusedDay: calenderState.selectedDate,
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
                      return isSameDay(calenderState.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (enabledDates.contains(DateTime(selectedDay.year,
                          selectedDay.month, selectedDay.day))) {
                        context.read<CalenderPickerCubit>().updateSelectedDate(selectedDay);
                        context.read<FetchSlotsSpecificdateBloc>().add(FetchSlotsSpecificdateRequst(selectedDay));
                      }
                    },
                    calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppPalette.buttonColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppPalette.buttonColor.withValues(alpha: 0.5),
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
                            child: Text(
                          '${day.day}',
                          style: TextStyle(color: AppPalette.greyColor),
                        ));
                      }
                      return Center(
                            child: Text(
                          '${day.day}',
                          style: TextStyle(color: AppPalette.buttonColor, fontWeight: FontWeight.w900),
                        ));
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
                focusedDay: calenderState.selectedDate,
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
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppPalette.buttonColor, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppPalette.buttonColor, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        color: AppPalette.buttonColor,
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
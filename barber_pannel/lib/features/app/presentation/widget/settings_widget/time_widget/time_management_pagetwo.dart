import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_specific_data_bloc/fetch_slot_specific_data_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/time_build_slot_page_two.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/time_management_page_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constant/constant.dart';

class TimeManagementPageTwo extends StatefulWidget {
  const TimeManagementPageTwo({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<TimeManagementPageTwo> createState() => _TimeManagementPageTwoState();
}

class _TimeManagementPageTwoState extends State<TimeManagementPageTwo> {
  @override
  void initState() {
    super.initState();
    _fetchSlotsForToday();
  }

  void _fetchSlotsForToday() {
    final selectedDate = context.read<CalenderPickerCubit>().state.selectedDate;
    context.read<FetchSlotsSpecificdateBloc>().add( FetchSlotsSpecificdateRequst(selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*--------------------------------------------
       Page Two – Calendar Picker Widget
      --------------------------------------------*/
      pageTwoCalenderPicker(),
      ConstantWidgets.hight30(context),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.08),
        child: blocBuilderSlotsPageTwo(screenHeight: widget.screenHeight, screenWidth: widget.screenWidth),
      ),
      ConstantWidgets.hight50(context),
    ]);
  }



}
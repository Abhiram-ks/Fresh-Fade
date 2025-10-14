import 'package:barber_pannel/features/app/presentation/state/cubit/time_picker_cubit/time_picker_cubit.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constant/constant.dart';

var timeManagementDatePIckerFunction = BlocBuilder<TimePickerCubit, TimePickerState>(
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                timePickerwidget( context: context,initialTime: state.startTime,
                    onTimeChanged: (newTime) => context.read<TimePickerCubit>().updateStartTime(newTime),
                    labelText: 'StartTime '),
                Text(
                  state.startTime.format(context),
                  style: const TextStyle( fontSize: 16, fontWeight: FontWeight.w500, ),
                ),
                ConstantWidgets.width20(context),
                timePickerwidget(
                    context: context, initialTime: state.endTime,
                    onTimeChanged: (newTime) =>context.read<TimePickerCubit>().updateEndtime(newTime),
                    labelText: 'EndTime '),
                Text(
                  state.endTime.format(context),
                  style: const TextStyle( fontSize: 16,fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        );
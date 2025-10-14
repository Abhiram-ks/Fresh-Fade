import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/generate_slots_bloc/generate_slot_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/handle_state_stot_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import '../../../state/cubit/duration_picker/duration_picker_cubit.dart';
import '../../../state/cubit/time_picker_cubit/time_picker_cubit.dart';

Padding generateSlotsActionbutton(BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
        child: BlocListener<GenerateSlotBloc, GenerateSlotState>(
          listener: (context, state) {
            handleSlotUploadState(context, state);
          },
          child: CustomButton(
              onPressed: () {
                final selectedDate = context.read<CalenderPickerCubit>().state.selectedDate;
                final startTime =  context.read<TimePickerCubit>().state.startTime;
                final endTime = context.read<TimePickerCubit>().state.endTime;
                final duration = context.read<DurationPickerCubit>().state;

                context.read<GenerateSlotBloc>().add(SlotGenerateRequest(
                    selectedDate: selectedDate,startTime: startTime,endTime: endTime,duration: duration));
              },
                text: 'Generate Slots',),
        ),
      );
  }
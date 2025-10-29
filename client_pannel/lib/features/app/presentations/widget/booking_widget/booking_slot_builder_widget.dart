
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_slots_specific_date_bloc/fetch_slots_specific_date_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/service_selection_cubit/service_selection_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/widgets/clip_chip_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../state/cubit/slot_selection_cubit/slot_selection_cubit.dart';

class BookingSlotBuilder extends StatelessWidget {
  const BookingSlotBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSlotsSpecificDateBloc,FetchSlotsSpecificDateState>(builder: (context, state) {
      if (state is FetchSlotsSpecificDateEmpty) {
        final String date = formatDate(state.selectedDate);
         return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight20(context),
              Icon(Icons.cloud_off_outlined, color: AppPalette.blackColor,size: 50,),
              Text( date),
              Text('No slots are available at the moment'),
              ConstantWidgets.hight30(context),
            ],
          ),
        );
      } else if (state is FetchSlotsSpecificDateFailure) {
                         return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight20(context),
              Icon(Icons.timer_off, color: AppPalette.redColor,size: 30,),
                Text("Oop's Unable to complete the request.",style: TextStyle(fontWeight: FontWeight.bold)),
               Text('Please try again later.',),
               ConstantWidgets.hight30(context)
            ],
          ),
        );
      } 
      else if (state is FetchSlotsSpecificDateLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyColor,
          highlightColor: AppPalette.whiteColor,
          child: Wrap(
            spacing: 4.0,
            runSpacing: 3.0,
            children: List.generate(12, (index) {
              return ClipChipMaker.build(
                text: '11:00 AM',
                actionColor: AppPalette.hintColor,
                textColor: AppPalette.blackColor,
                backgroundColor:
                    AppPalette.whiteColor,
                borderColor: AppPalette.hintColor,
                onTap: () {},
              );
            }),
          ),
        );
      }
      if (state is FetchSlotsSpecificDateSuccess) {
        final slots = state.slots;
        final slotSelectionCubit =  context.watch<SlotSelectionCubit>();
        final maxSelectableSlots = context
            .watch<ServiceSelectionCubit>()
            .state
            .selectedServices
            .length;
    
        return Wrap(
          spacing: 3.0,
          runSpacing: 3.0,
          children: slots.map((slot) {
            final isSelected =
                slotSelectionCubit.isSlotSelected(slot.subDocId);
            String formattedStartTime =
                formatTimeRange(slot.startTime);
            final selectedSlotCount =
                slotSelectionCubit.state.selectedSlots.length;
            final bool isTimeExceeded =
                isSlotTimeExceeded(slot.docId, formattedStartTime);
    
            return ClipChipMaker.build(
              text: formattedStartTime,
              actionColor: slot.available
                  ? const Color.fromARGB(255, 237, 237, 238)
                  : Colors.transparent,
              textColor: isSelected
                  ? AppPalette.whiteColor
                  : slot.booked
                      ? AppPalette.greyColor
                      : isTimeExceeded
                          ? AppPalette.whiteColor
                          : slot.available
                              ? AppPalette.blackColor
                              : AppPalette.whiteColor,
              backgroundColor: isSelected
                  ? AppPalette.buttonColor
                  : slot.booked
                      ? const Color.fromARGB(255, 226, 228, 231)
                      : isTimeExceeded
                          ? const Color.fromARGB(255, 236, 236, 238)
                          : slot.available
                              ? AppPalette.whiteColor
                              : AppPalette.redColor
                                  .withAlpha((0.7 * 255).toInt()),
              borderColor: isSelected
                  ? AppPalette.orengeColor
                  : slot.booked
                      ? AppPalette.hintColor
                      : isTimeExceeded
                          ? const Color.fromARGB(255, 226, 228, 231)
                          : AppPalette.hintColor,
              onTap: () {
                final bool canSelectSlot = !slot.booked &&
                    slot.available &&
                    !isTimeExceeded &&
                    maxSelectableSlots > 0 &&
                    (isSelected ||
                        selectedSlotCount < maxSelectableSlots);
                if (canSelectSlot) {
                  context .read<SlotSelectionCubit>()  .toggleSlot(slot, maxSelectableSlots);
                }
              },
            );
          }).toList(),
        );
      }
    
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstantWidgets.hight30(context),
            Icon(Icons.cloud_off_outlined, color: AppPalette.blueColor,size: 50,),
            Text(
              "Unable to complete the request.",
              style: TextStyle(color: AppPalette.greyColor),
            ),
            Text('Something went wrong. Try different date.')
          ],
        ),
      );
    
    });
  }
}

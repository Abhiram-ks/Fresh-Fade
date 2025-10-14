import 'package:barber_pannel/features/app/presentation/screens/setting/service_manage/service_manage_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_specific_data_bloc/fetch_slot_specific_data_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/handle_state_update_slote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../../service/formalt/data_time_formalt.dart';
import '../../../state/bloc/modify_slots_generate_bloc/modify_slots_generate_bloc.dart';

BlocBuilder<FetchSlotsSpecificdateBloc, FetchSlotsSpecificDateState> blocBuilderSlotsPageTwo({required double screenWidth, required double screenHeight}) {
    return BlocBuilder<FetchSlotsSpecificdateBloc, FetchSlotsSpecificDateState>(
        builder: (context, state) {
          if (state is FetchSlotsSpecificDateEmpty) {
               return Center(
         child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text( '${state.salectedDate.day}/${state.salectedDate.month}/${state.salectedDate.year}'),
                 ConstantWidgets.hight20(context),
                 Text('Empty Availability',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                Text('No slots are available at the moment',textAlign: TextAlign.center,style: TextStyle(fontSize: 13,),),
              ],
            ),
     );
          } 
          else if (state is FetchSlotsSpecificDateFailure) {
                return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.calendar_badge_minus),
                Text( "Something went wrong.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                Text( state.errorMessage,textAlign: TextAlign.center,style: TextStyle(fontSize: 12,),),
                  
                IconButton(onPressed: (){
                 final selectedDate = context.read<CalenderPickerCubit>().state.selectedDate;
                  context.read<FetchSlotsSpecificdateBloc>().add( FetchSlotsSpecificdateRequst(selectedDate));
                }, icon:   Icon(CupertinoIcons.refresh,))
              
              ],
            );
          } 
          else if (state is FetchSlotsSpecificDateLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300] ?? AppPalette.greyColor,
              highlightColor: AppPalette.whiteColor,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row( 
                      children: List.generate(5, (index) {
                        return colorMarker(
                          context: context,
                          hintText: 'Mark Unavailable',
                          markColor: AppPalette.buttonColor,
                        );
                      }),
                    ),
                  ),
                  ConstantWidgets.hight30(context),
                  Column(
                    children: List.generate(5, (index) {
                      return ServiceManagementFiled(
                        context: context,
                        icon: Icons.timer,
                        screenWidth: screenWidth,
                        label: 'avalable',
                        serviceRate: '--:-- AM?PM',
                        deleteAction: () {},
                        updateIcon: CupertinoIcons.circle,
                        updateAction: (value) {},
                      );
                    }),
                  ),
                ],
              ),
            );
          }
          if (state is FetchSlotsSpecificDateLoaded) {
            final slots = state.slots;
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      colorMarker(context: context,hintText: 'Mark Unavailable',markColor: AppPalette.buttonColor),
                      colorMarker(context: context,hintText: 'Mark Available',markColor: AppPalette.greyColor),
                      colorMarker(context: context,hintText: 'Booked',markColor: AppPalette.greenColor),
                      colorMarker(context: context,hintText: 'Time Exceeded',markColor: AppPalette.hintColor),
                    ],
                  ),
                ),
                ConstantWidgets.hight30(context),
                BlocListener<ModifySlotsGenerateBloc, ModifySlotsGenerateState>(
                  listener: (context, state) {
                    handleSlotUpdatesState(context, state);
                  },
                  child: Column(
                    children: slots.map((slot) {
                      String formattedStartTime = formatTimeRange(slot.startTime);
                      String formattedEndTime = formatTimeRange(slot.endTime);
                      final bool isTimeExceeded = isSlotTimeExceeded(slot.docId, formattedStartTime);

                      return ServiceManagementFiled(
                        context: context,
                        icon: Icons.timer,
                        screenWidth: screenWidth,
                        firstIconColor: slot.booked
                            ? AppPalette.greenColor.withAlpha(128)
                            : AppPalette.whiteColor,
                        firstIconBgColor: slot.booked
                            ? AppPalette.trasprentColor
                            : slot.available
                                ? (isTimeExceeded
                                    ? AppPalette.greyColor.withAlpha(50)
                                    : AppPalette.greyColor)
                                : (isTimeExceeded
                                    ? AppPalette.greenColor.withAlpha(50)
                                    : AppPalette.buttonColor),
                        secoundIconColor: slot.booked
                            ? AppPalette.greenColor.withAlpha(128)
                            : (isTimeExceeded
                                ? AppPalette.whiteColor
                                : AppPalette.whiteColor),
                        secoundIconBgColor: slot.booked
                            ? AppPalette.trasprentColor
                            : (isTimeExceeded
                                ? AppPalette.redColor.withAlpha(50)
                                : AppPalette.redColor),
                        label: slot.booked
                            ? 'Booked'
                            : slot.available
                                ? (isTimeExceeded
                                    ? 'Available (Time Exceeded)'
                                    : 'Available')
                                : (isTimeExceeded
                                    ? 'Unavailable (Time Exceeded)'
                                    : 'Unavailable'),
                        serviceRate: "$formattedStartTime - $formattedEndTime",
                        updateDeletIcon: slot.booked
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.delete_solid,
                        updateIcon: slot.booked
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.clear,
                        deleteAction: () {
                          if (slot.booked == false) {
                            context.read<ModifySlotsGenerateBloc>().add(
                                RequestDeleteGeneratedSlotEvent(shopId: slot.shopId,docId: slot.docId,subDocId: slot.subDocId, time: "$formattedStartTime - $formattedEndTime"));
                          }
                        },
                        updateOntap: () {
                          if (slot.booked == false && isTimeExceeded == false) {
                            context.read<ModifySlotsGenerateBloc>().add(
                                ChangeSlotStatusEvent( shopId: slot.shopId,docId: slot.docId,subDocId: slot.subDocId,status: slot.available ? false : true));
                          }
                        },
                        updateAction: (value) {},
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
            return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Unable to complete the request.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Please try again later.',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,),),
            ],
          ),
        );

        },
      );
  }

  

Row colorMarker(
    {required BuildContext context,
    required Color markColor,
    required String hintText}) {
  return Row(children: [
    Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: markColor, shape: BoxShape.rectangle,
        )),
    ConstantWidgets.width20(context),
    Text(hintText),
    ConstantWidgets.width40(context)
  ]);
}


import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import 'package:client_pannel/features/app/presentations/screen/search/payment_summary/payment_summary.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/slot_selection_cubit/slot_selection_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/payment_widget/bottom_sheet_payment_option.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cod_payment_bloc/cod_payment_bloc.dart';

void handleOnlinePaymentStates({required BuildContext context,required CodPaymentState state,required String totalAmount,required  String barberUid,required List<Map<String, dynamic>> selectedServices, required double screenWidth, required double screenHeight, required List<SlotModel> selectedSlots, required double platformFee, required double  totalInINR, required  SlotSelectionCubit slotSelectionCubit, required String labelText}) {
    final buttonCubit = context.read<ProgresserCubit>();


  if (state is OnlinePaymentSlotAvailable) {
    buttonCubit.stopLoading();
     BottomSheetPaymentOption().showBottomSheet(
      context: context, screenHeight: screenHeight,screenWidth: screenWidth,
      walletPaymentAction: () {
        Navigator.pop(context);
        context.read<CodPaymentBloc>().add(CodPaymentCheckSlotsRequested(selectedSlots: selectedSlots, 
        barberId: barberUid, 
        bookingAmount: totalInINR,
        selectedServices: selectedServices, 
        platformFee: platformFee));
        },
      stripePaymentAction: () async {
        Navigator.pop(context);
        });
  }else if (state is OnlinePaymentLoading){
    buttonCubit.startLoading();
  }else if (state is OnlinePaymentSuccess) {
    buttonCubit.stopLoading();
        Navigator.of(context).push(
        MaterialPageRoute(
           builder: (context) =>PaymentSummaryScreen(totalAmount: totalAmount, barberUid: barberUid, selectedServices: selectedServices, selectedSlots: selectedSlots, platformFee: platformFee, totalInINR: totalInINR, ),
        ),
      );
  } else if(state is OnlinePaymentSlotNotAvailable){
    buttonCubit.stopLoading();
     Navigator.pop(context);
  }
  else if(state is OnlinePaymentFailure){
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.error,backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
  }
}

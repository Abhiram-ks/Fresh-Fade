import 'package:client_pannel/core/common/custom_appbar.dart';
import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import 'package:client_pannel/features/app/presentations/screen/search/payment_summary/payment_summary.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/slot_selection_cubit/slot_selection_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/cod_payment_bloc/cod_payment_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/payment_widget/paymeent_state_handle.dart';
import 'package:client_pannel/features/app/presentations/widget/payment_widget/payment_top_portion.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/common/custom_button.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import '../../../widget/payment_widget/calucation_login_widget.dart';
import '../../../widget/payment_widget/payment_bottom_section_widget.dart';

class PaymentScreen extends StatelessWidget {
  final String barberUid;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final SlotSelectionCubit slotSelectionCubit;

  const PaymentScreen({
    super.key,
    required this.barberUid,
    required this.selectedSlots,
    required this.slotSelectionCubit,
    required this.selectedServices,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount = getTotalServiceAmount(selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);
    final double displayPrice = totalAmount + platformFee;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FetchAbarberBloc>()),
        BlocProvider.value(value: slotSelectionCubit),
        BlocProvider(create: (_) => sl<ProgresserCubit>()),
        BlocProvider(create: (_) => sl<CodPaymentBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            backgroundColor: AppPalette.whiteColor,
            appBar: CustomAppBar2(
              backgroundColor: AppPalette.orengeColor,
              isTitle: true,
              title: 'Payment Details',
              titleColor: AppPalette.whiteColor,
              iconColor: AppPalette.whiteColor,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ColoredBox(
                color: AppPalette.orengeColor,
                child: SafeArea(
                  child: Column(
                    children: [
                      ConstantWidgets.hight10(context),
                      PaymentTopPortion(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        barberUId: barberUid,
                      ),
                      ConstantWidgets.hight30(context),
                      PaymentBottomSectionWidget(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        selectedSlots: selectedSlots,
                        selectedServices: selectedServices,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: screenWidth * 0.9,
              height: 45,
              child: BlocListener<CodPaymentBloc, CodPaymentState>(
                listener: (context, state) {
                  handleOnlinePaymentStates(context: context, state: state, totalAmount: totalAmount.toStringAsFixed(2), barberUid: barberUid, selectedServices: selectedServices,screenWidth: screenWidth, screenHeight: screenHeight, selectedSlots: selectedSlots, platformFee: platformFee, totalInINR: displayPrice, slotSelectionCubit: slotSelectionCubit, labelText: 'Pay');
                },
                child: CustomButton(
                  text: 'Pay ₹ ${displayPrice.toStringAsFixed(2)}',
                  bgColor: AppPalette.greenColor,
                  onPressed: () {
                    context.read<CodPaymentBloc>().add(
                      CodPaymentCheckSlots(
                        barberId: barberUid,
                        selectedSlots: selectedSlots,
                      ),
                    );
                   
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



          //  BlocBuilder<CurrencyConversionCubit, CurrencyConversionState>(
          //   builder: (context, convertionState) {
          //     return BlocListener<OnlinePaymentBloc, OnlinePaymentState>(
          //       listener: (context, state) {
          //         handleOnlinePaymentStates(context: context, state: state, totalAmount: totalInINR.toStringAsFixed(2), barberUid: barberUid, selectedServices: selectedServices,convertionState: convertionState,labelText: labelText,platformFee: platformFee,screenHeight: screenHeight,screenWidth: screenWidth,selectedSlots: selectedSlots, slotSelectionCubit:slotSelectionCubit, totalInINR: totalInINR);
          //       },
          //       child: SizedBox(
          //           width: screenWidth * 0.9,
          //           child: ButtonComponents.actionButton(
          //             screenHeight: screenHeight,
          //             screenWidth: screenWidth,
          //             buttonColor: AppPalette.greenClr,
          //             label: labelText,
          //             onTap: () {
          //             context.read<OnlinePaymentBloc>().add(OnlinePaymentCheckSlots(barberId: barberUid, selectedSlots: selectedSlots));

                     
          //               })),
          //     );
          //   },
          // ),
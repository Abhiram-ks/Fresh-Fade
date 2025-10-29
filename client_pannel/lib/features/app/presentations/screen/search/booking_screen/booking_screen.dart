
import 'package:client_pannel/core/common/custom_button.dart';
import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/features/app/presentations/screen/search/payment_screen/payment_screen.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_slots_specific_date_bloc/fetch_slots_specific_date_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/service_selection_cubit/service_selection_cubit.dart' show ServiceSelectionCubit;
import 'package:client_pannel/features/app/presentations/state/cubit/slot_selection_cubit/slot_selection_cubit.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/common/custom_appbar.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/di/di.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import '../../../state/bloc/fetch_bloc/fetch_slots_datas_bloc/fetch_slots_dates_bloc.dart';
import '../../../widget/booking_widget/booking_body_widget.dart';

class BookingScreen extends StatelessWidget {
  final String shopId;
  const BookingScreen({super.key, required this.shopId});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceSelectionCubit()),
        BlocProvider(create: (_) => ProgresserCubit()),
        BlocProvider(create: (_) => SlotSelectionCubit()),
        BlocProvider(create: (_) => CalenderPickerCubit()),
        BlocProvider(create: (_) => sl<FetchBarberServiceBloc>()),
        BlocProvider(create: (_) => sl<FetchSlotsSpecificDateBloc>()),
        BlocProvider(create: (_) => sl<FetchSlotsDatesBloc>()),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;
        return SafeArea(
         child: Scaffold(
          appBar: CustomAppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Appointment',
                    style: GoogleFonts.plusJakartaSans( fontSize: 28, fontWeight: FontWeight.bold)),
                    ConstantWidgets.hight10(context),
                    Text('Almost there! Pick a date, choose services, select a time slot, and proceed to payment.'),
                    ConstantWidgets.hight10(context),
                  ],
                ),
              ),
              BookinScreenWidgets(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  barberid: shopId)
            ]),
          ),
          floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
              width: screenWidth * 0.9,
              height: 45,

              child: CustomButton(text: 'Deal booking', onPressed: (){
                final selectedServices = context.read<ServiceSelectionCubit>().state.selectedServices;
                final selectedSlots = context.read<SlotSelectionCubit>().state.selectedSlots;
                final slotSelectionCubit = context.read<SlotSelectionCubit>();


                if (selectedSlots.length != selectedServices.length  || selectedSlots.isEmpty || selectedServices.isEmpty) {
                  CustomSnackBar.show(
                  context, 
                  message: 'Session Error Detected!. It looks like there was a mistake. Select the appropriate services and choose a valid time slot.',
                  backgroundColor: AppPalette.redColor,
                  textAlign: TextAlign.center,
                  );
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(barberUid: shopId, selectedSlots: selectedSlots, selectedServices: selectedServices,slotSelectionCubit:  slotSelectionCubit,)));
              })
           ),
        ));
      }),
    );
  }
}

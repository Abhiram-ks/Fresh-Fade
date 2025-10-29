import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/widget/booking_widget/booking_calender_bloc_builder.dart';
import 'package:client_pannel/features/app/presentations/widget/booking_widget/booking_service_builder.dart';
import 'package:client_pannel/features/app/presentations/widget/booking_widget/booking_slot_builder_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/booking_widget/color_indicator_maker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/constant.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import '../../state/bloc/fetch_bloc/fetch_slots_datas_bloc/fetch_slots_dates_bloc.dart';
import '../../state/bloc/fetch_bloc/fetch_slots_specific_date_bloc/fetch_slots_specific_date_bloc.dart';
import '../../state/cubit/calender_picker_cubit/calender_picker_cubit.dart';

class BookinScreenWidgets extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String barberid;

  const BookinScreenWidgets(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.barberid});

  @override
  State<BookinScreenWidgets> createState() => _BookinScreenWidgetsState();
}

class _BookinScreenWidgetsState extends State<BookinScreenWidgets> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchSlotsDatesBloc>().add(FetchSlotsDatesRequested(barberId: widget.barberid));
      context.read<FetchBarberServiceBloc>().add(FetchBarberServiceRequest(barberId: widget.barberid));
      _fetchSlotsForToday();
    });
  }

  void _fetchSlotsForToday() {
    final selectedDate = context.read<CalenderPickerCubit>().state.selectedData;
    context.read<FetchSlotsSpecificDateBloc>().add(FetchSlotSpecificDateRequested(barberId: widget.barberid, selectedDate: selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingCalenderBlocBuilder(
          barberId: widget.barberid,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidgets.hight10(context),
              Text('Choose Service',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              BookingServiceBuilder(),
              ConstantWidgets.hight10(context),
               Text('Status Indicators', style: TextStyle(fontWeight: FontWeight.w900)),
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      colorMarker(context: context,hintText: 'Reserve Time',markColor: AppPalette.buttonColor),
                      colorMarker(context: context,hintText: 'Active Slots',markColor: const Color.fromARGB(255, 239, 239, 239)),
                      colorMarker(context: context,hintText: 'Disabled Slots',markColor:const Color.fromARGB(255, 237, 237, 238)),
                      colorMarker(context: context,hintText: 'Booked Slots',markColor: AppPalette.hintColor),
                    ],
                  ),
                ),
             ConstantWidgets.hight10(context),
              Text('Available time', style: TextStyle(fontWeight: FontWeight.w900)),
             BookingSlotBuilder(),
            ],
          ),
        ),
        ConstantWidgets.hight50(context),
        ConstantWidgets.hight30(context)
      ],
    );
  }
}

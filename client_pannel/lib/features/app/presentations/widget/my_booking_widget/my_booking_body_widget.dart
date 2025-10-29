import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/my_booking_widget/my_booking_filter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import 'my_booking_list_widget.dart';

class MyBookingWidgets extends StatefulWidget {
  const MyBookingWidgets({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<MyBookingWidgets> createState() => _MyBookingWidgetsState();
}

class _MyBookingWidgetsState extends State<MyBookingWidgets> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingWithBarberBloc>()
          .add(FetchBookingWithBarberRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bookings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'Stay on top of your schedule — check the status of every booking and review all your appointment details anytime.',
              ),
              ConstantWidgets.hight20(context),
              MybookingFilteringCards(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: MyBookingListWIdget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}

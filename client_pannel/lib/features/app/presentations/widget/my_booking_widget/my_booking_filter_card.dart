
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/my_booking_widget/my_booking_custom_filter_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/app_colors.dart';

class MybookingFilteringCards extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const MybookingFilteringCards({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.048,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            BookingFilteringCards(
              label: 'All Booking',
              icon: Icons.history_rounded,
              colors: Colors.black,
              onTap: () {
                 context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberRequest());
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Completed',
              icon: Icons.check_circle_outline_sharp,
              colors: Colors.green,
              onTap: () {
             context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFilter(filter: 'completed'));
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redColor,
              onTap: () {
               context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFilter(filter: 'cancelled'));
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeColor,
              onTap: () {
               context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFilter(filter: 'pending'));
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Timeout',
              icon: Icons.timer,
              colors: AppPalette.blueColor,
              onTap: () {
               context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFilter(filter: 'timeout'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
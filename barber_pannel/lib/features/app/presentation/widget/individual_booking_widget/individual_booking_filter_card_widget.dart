import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_individual_user_booking_bloc/fetch_individual_user_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/booking_custom_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndivitualBookingFilteringCards extends StatelessWidget {
  final String userId;
  final double screenWidth;
  final double screenHeight;

  const IndivitualBookingFilteringCards({
    super.key,
    required this.userId,
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
                context.read<FetchIndividualUserBookingBloc>().add(
                  FetchIndividualUserBookingRequested(userId: userId),
                );
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Completed',
              icon: Icons.check_circle_outline_sharp,
              colors: Colors.green,
              onTap: () {
                context.read<FetchIndividualUserBookingBloc>().add(
                  FetchIndividualUserBookingFiltered(status: 'completed', userId: userId),
                );
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redColor,
              onTap: () {
                context.read<FetchIndividualUserBookingBloc>().add(
                  FetchIndividualUserBookingFiltered(status: 'cancelled', userId: userId),
                );
              },
            ),
            VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeColor,
              onTap: () {
                context.read<FetchIndividualUserBookingBloc>().add(
                  FetchIndividualUserBookingFiltered(status: 'pending', userId: userId),
                );
              },
            ),
             VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Timeout',
              icon: Icons.timer,
              colors: AppPalette.blueColor,
              onTap: () {
                context.read<FetchIndividualUserBookingBloc>().add(
                  FetchIndividualUserBookingFiltered(status: 'timeout', userId: userId),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

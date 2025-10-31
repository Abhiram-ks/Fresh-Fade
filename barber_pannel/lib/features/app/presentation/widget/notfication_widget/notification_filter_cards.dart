
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/booking_custom_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationFilterCards extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const NotificationFilterCards({
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
              label: 'Timeout',
              icon: Icons.timer,
              colors: AppPalette.blueColor,
              onTap: () {
                context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'timeout'),
                );
              },
            ),
             VerticalDivider(color: AppPalette.hintColor),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeColor,
              onTap: () {
                context.read<FetchBookingWithUserBloc>().add(
                  FetchBookingWithUserFilteredRequested(status: 'pending'),
                );
              },
            ),
          
          ],
        ),
      ),
    );
  }
}

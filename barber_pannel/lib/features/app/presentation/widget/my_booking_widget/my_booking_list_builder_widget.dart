import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/transaction_custom_card_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/post_widget/post_bloc_success_state_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../screens/setting/booking_detail_screen/booking_detail_screen.dart';
import '../../state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';

class BookingListWIdget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const BookingListWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteColor,
      color: AppPalette.buttonColor,
      onRefresh: () async {
        context.read<FetchBookingWithUserBloc>().add(
          FetchBookingWithUserRequested(),
        );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal:
              screenWidth > 600 ? screenWidth * .15 : screenWidth * 0.04,
        ),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithUserBloc, FetchBookingWithUserState>(
              builder: (context, state) {
                if (state is FetchBookingWithUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.hintColor,
                    highlightColor: AppPalette.whiteColor,
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: ListView.separated(
                        separatorBuilder:
                            (context, index) =>
                                ConstantWidgets.hight10(context),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return TrasactionCardsWalletWidget(
                            ontap: () {},
                            screenHeight: screenHeight,
                            mainColor: AppPalette.hintColor,
                            amount: '+ ₹500.00',
                            amountColor: AppPalette.hintColor,
                            status: 'Loading..',
                            statusIcon: Icons.check_circle_outline_outlined,
                            id: 'Transaction #${index + 1}',
                            stusColor: AppPalette.hintColor,
                            dateTime: DateTime.now().toString(),
                            method: 'Online Banking',
                            description:
                                "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingWithUserEmpty) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidgets.hight50(context),
                        Image.asset(AppImages.appLogo, width: 50, height: 50),
                        Text(
                          "No records available at this time.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "No activity found time to take action!",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                } else if (state is FetchBookingWithUserSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.bookings.length,
                    separatorBuilder:
                        (_, __) => ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final isUserName =
                          booking.user.name.isNotEmpty &&
                          booking.user.name != 'null';
                      final String date = formatDate(booking.booking.createdAt);
                      final String time = formatTimeRange(
                        booking.booking.createdAt,
                      );
                      return TrasactionCardsWalletWidget(
                        ontap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) => BookingDetailsScreen(
                                    barberId: booking.booking.barberId,
                                    userId: booking.booking.userId,
                                    docId: booking.booking.bookingId ?? '',
                                  ),
                            ),
                          );
                        },
                        screenHeight: screenHeight,
                        amount: booking.booking.otp,
                        amountColor: switch (booking.booking.status
                            .toLowerCase()) {
                          'completed' => AppPalette.greenColor,
                          'pending' => AppPalette.orengeColor,
                          'cancelled' => AppPalette.redColor,
                          'timeout' => AppPalette.blueColor,
                          _ => AppPalette.hintColor,
                        },
                        dateTime: '$date At $time',
                        description:
                            isUserName
                                ? 'Booking by : ${booking.user.name}'
                                : 'Booking by: ${booking.user.email}',
                        id: 'Payment Method: ${booking.booking.paymentMethod}',
                        method: booking.user.address ?? 'No Address Provided',
                        status: booking.booking.status,
                        statusIcon: switch (booking.booking.status
                            .toLowerCase()) {
                          'completed' => Icons.check_circle_outline_outlined,
                          'pending' => Icons.pending_actions_rounded,
                          'cancelled' => Icons.free_cancellation_rounded,
                          'timeout' => Icons.timer,
                          _ => Icons.help_outline,
                        },
                        stusColor: switch (booking.booking.status
                            .toLowerCase()) {
                          'completed' => AppPalette.greenColor,
                          'pending' => AppPalette.orengeColor,
                          'cancelled' => AppPalette.redColor,
                          'timeout' => AppPalette.blueColor,
                          _ => AppPalette.hintColor,
                        },
                        transactionColor: switch (booking.booking.status
                            .toLowerCase()) {
                          'completed' => AppPalette.greenColor,
                          'pending' => AppPalette.orengeColor,
                          'cancelled' => AppPalette.redColor,
                          'timeout' => AppPalette.blueColor,
                          _ => AppPalette.hintColor,
                        },
                      );
                    },
                  );
                }

                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight50(context),
                      Text(
                        "Something went wrong. We're having trouble processing your request. Please try again.",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<FetchBookingWithUserBloc>().add(
                            FetchBookingWithUserRequested(),
                          );
                        },
                        icon: Icon(CupertinoIcons.refresh),
                      ),
                    ],
                  ),
                );
              },
            ),
            ConstantWidgets.hight20(context),
          ],
        ),
      ),
    );
  }
}

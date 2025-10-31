import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/booking_detail_screen/booking_detail_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/booking_status_update_bloc/booking_status_update_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/transaction_custom_card_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/post_widget/post_bloc_success_state_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'notification_handle_state.dart';

RefreshIndicator notificationWidgetBuilder(
  BuildContext context,
  double screenHeight,
  double screenWidth,
) {
  return RefreshIndicator(
    backgroundColor: AppPalette.whiteColor,
    color: AppPalette.buttonColor,
    onRefresh: () async {
      context.read<FetchBookingWithUserBloc>().add(
        FetchBookingWithUserFilteredRequested(status: 'timeout'),
      );
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              screenWidth > 600 ? screenWidth * .15 : screenWidth * 0.02,
        ),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithUserBloc, FetchBookingWithUserState>(
              builder: (context, state) {
                if (state is FetchBookingWithUserLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                    highlightColor: AppPalette.whiteColor,
                    child: SizedBox(
                      height: screenHeight * 0.6,
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
                            amountColor: AppPalette.greyColor,
                            status: 'Loading..',
                            statusIcon: Icons.check_circle_outline_outlined,
                            id: 'Transaction #${index + 1}',
                            stusColor: AppPalette.greyColor,
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
                          "You have no notifications at the moment.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "No Notification yet!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
                else if (state is FetchBookingWithUserSuccess) {
                  return BlocListener<
                    BookingStatusUpdateBloc,
                    BookingStatusUpdateState
                  >(
                    listener: (context, state) {
                      handleNotifiactionState(context, state);
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.bookings.length,
                      separatorBuilder:(_, __) => ConstantWidgets.hight10(context),
                      itemBuilder: (context, index) {
                        final booking = state.bookings[index];
                        final DateTime converter = convertToDateTime(
                          booking.booking.slotDate,
                        );
                        final String date = formatDate(converter);

                        return TrasactionCardsWalletWidget(
                          ontap: () {
                            if (booking.booking.status.toLowerCase()=='timeout') {
                              context.read<BookingStatusUpdateBloc>().add(
                                BookingStatusUpdateRequested(
                                  docId: booking.booking.bookingId ?? '',
                                  barberId: booking.booking.barberId,
                                  isAll: false,
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BookingDetailsScreen(
                                        barberId: booking.booking.barberId,
                                        userId: booking.booking.userId,
                                        docId: booking.booking.bookingId ?? ' ',
                                      ),
                                ),
                              );
                            }
                          },
                          screenHeight: screenHeight,
                          amount: booking.booking.otp,
                          amountColor: booking.booking.status.toLowerCase() == 'pending'
                                  ? AppPalette.orengeColor
                                  : AppPalette.blueColor,
                          dateTime: date,
                          description: 'Booking Name: ${booking.user.name}',
                          id: 'Method: ${booking.booking.paymentMethod}',
                          method:
                              'Address: ${booking.user.address ?? 'No address availble at the moment'}',
                          status: booking.booking.status,
                          statusIcon:
                              booking.booking.status.toLowerCase() == 'pending'
                                  ? Icons.pending_actions_rounded
                                  : Icons.timer,
                          stusColor:
                              booking.booking.status.toLowerCase() == 'pending'
                                  ? AppPalette.orengeColor
                                  : AppPalette.blueColor,
                          transactionColor:
                              booking.booking.status.toLowerCase() == 'pending'
                                  ? AppPalette.orengeColor
                                  : AppPalette.blueColor,
                        );
                      },
                    ),
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
                            FetchBookingWithUserFilteredRequested(
                              status: 'timeout',
                            ),
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
    ),
  );
}

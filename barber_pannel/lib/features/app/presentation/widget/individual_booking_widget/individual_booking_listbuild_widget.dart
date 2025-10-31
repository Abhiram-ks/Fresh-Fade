
import 'package:barber_pannel/core/common/custom_lottie.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/booking_detail_screen/booking_detail_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_individual_user_booking_bloc/fetch_individual_user_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/transaction_custom_card_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/post_widget/post_bloc_success_state_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class IndivitualBookingListWidget extends StatelessWidget {
  final double screenWidth;
  final String userId;
  final double screenHeight;
  const IndivitualBookingListWidget(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteColor,
      color: AppPalette.buttonColor,
      onRefresh: () async {
        context.read<FetchIndividualUserBookingBloc>().add(FetchIndividualUserBookingRequested(userId: userId));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchIndividualUserBookingBloc, FetchIndividualUserBookingState>(
              builder: (context, state) {
                if (state is FetchIndividualUserBookingLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.hintColor,
                    highlightColor: AppPalette.whiteColor,
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
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
                } else if (state is FetchIndividualUserBookingEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                          Image.asset(AppImages.appLogo, width: 50, height: 50,),
                          Text("No records available at this time.", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("No activity found time to take action!",
                              style: TextStyle(fontSize: 12))
                        ]),
                  );
                } 
                else if (state is FetchIndividualUserBookingSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final isOnline =booking.status.toLowerCase().contains('credit');
                      final DateTime converter = convertToDateTime(booking.slotDate);
                      final String date = formatDate(converter);
                      final double totalServiceAmount = booking
                          .serviceType.values
                          .fold(0.0, (sum, value) => sum + value);
                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingDetailsScreen(
                                        barberId: booking.barberId,
                                        userId: booking.userId,
                                        docId: booking.bookingId!)));
                          },
                          screenHeight: screenHeight,
                          transactionColor: switch (
                              booking.status.toLowerCase()) {
                            'completed' => AppPalette.greenColor,
                            'pending' => AppPalette.orengeColor,
                            'cancelled' => AppPalette.redColor,
                            'timeout' => AppPalette.blueColor,
                            _ => AppPalette.hintColor,
                          },
                          amount: totalServiceAmount.toStringAsFixed(2),
                          amountColor: switch (
                              booking.status.toLowerCase()) {
                            'completed' => AppPalette.greenColor,
                            'pending' => AppPalette.orengeColor,
                            'cancelled' => AppPalette.redColor,
                            'timeout' => AppPalette.blueColor,
                            _ => AppPalette.hintColor,
                          },
                          dateTime: date,
                          description: isOnline
                              ? 'Sent ₹${totalServiceAmount.toStringAsFixed(2)} via ${booking.paymentMethod}'
                              : 'Received ₹${totalServiceAmount.toStringAsFixed(2)} via ${booking.paymentMethod}',
                          id: 'Booking code: ${booking.otp}',
                          method: 'Payment Method: ${booking.paymentMethod}',
                          status: booking.status,
                          statusIcon: switch (
                              booking.status.toLowerCase()) {
                            'completed' => Icons.check_circle_outline_outlined,
                            'pending' => Icons.pending_actions_rounded,
                            'cancelled' => Icons.free_cancellation_rounded,
                            'timeout' => Icons.timer,
                            _ => Icons.help_outline,
                          },
                          stusColor: switch (
                              booking.status.toLowerCase()) {
                            'completed' => AppPalette.greenColor,
                            'pending' => AppPalette.orengeColor,
                            'cancelled' => AppPalette.redColor,
                            'timeout' => AppPalette.blueColor,
                            _ => AppPalette.hintColor,
                          });
                    },
                  );
                }

                return Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.cloud_download_fill),
                        Text(
                            "Something went wrong. We're having trouble processing your request. Please try again.", style: TextStyle(fontSize: 12),),
                            IconButton(onPressed: (){
                              context
                                  .read<FetchIndividualUserBookingBloc>()
                                  .add(FetchIndividualUserBookingRequested(userId: userId));
                            },icon:  Icon( CupertinoIcons.refresh))
                      ]),
                );
              },
            ),
            ConstantWidgets.hight20(context)
          ],
        ),
      ),
    );
  }
}
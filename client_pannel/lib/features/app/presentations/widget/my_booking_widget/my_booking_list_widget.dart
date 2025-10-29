
import 'package:client_pannel/core/images/app_images.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/my_booking_widget/my_booking_transation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../screen/settings/my_booking_detail_screen/my_booking_detail_screen.dart';

class MyBookingListWIdget extends StatelessWidget {
  const MyBookingListWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteColor,
      color: AppPalette.buttonColor,
      onRefresh: () async {
        context.read<FetchBookingWithBarberBloc>()
            .add(FetchBookingWithBarberRequest());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithBarberBloc,
                FetchBookingWithBarberState>(
              builder: (context, state) {
                if (state is FetchBookingWithBarberLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                    highlightColor: AppPalette.whiteColor,
                    child: SizedBox(
                      height: screenHeight * 0.8,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
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
                } else if (state is FetchBookingWithBarberEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                       Image.asset(AppImages.appLogo, height: 50, width: 50, fit: BoxFit.contain,),
                       Text("There's nothing here yet.",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("No activity found time to take action!",
                              style: TextStyle(color: AppPalette.blackColor, fontSize: 11))
                        ]),
                  );
                }
                 else if (state is FetchBookingWithBarberSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final date = formatDate(booking.booking.createdAt);
                      final formattedStartTime = formatTimeRange(booking.booking.createdAt);

                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyBookingDetailScreen(
                                      docId: booking.booking.bookingId ?? '',
                                      barberId: booking.booking.barberId,
                                      userId: booking.booking.userId),
                                ));
                          },
                          screenHeight: screenHeight,
                          amount: () {
                            final gender = booking.barber.gender?.toLowerCase();
                            if (gender == 'male') return 'Male';
                            if (gender == 'female') return 'Female';
                            return 'Unisex';
                          }(),
                          amountColor: (() {
                            final gender = booking.barber.gender?.toLowerCase();
                            if (gender == 'male') return AppPalette.blueColor;
                            if (gender == 'female') return Colors.pink;
                            return AppPalette.orengeColor;
                          })(),
                          dateTime: '$date At $formattedStartTime',
                          description: booking.barber.ventureName,
                          id: 'Booking Code: ${booking.booking.otp}',
                          method: booking.barber.address,
                          status: booking.booking.status,
                          statusIcon: switch (
                              booking.booking.status.toLowerCase()) {
                            'completed' => Icons.check_circle_outline_outlined,
                            'pending' => Icons.pending_actions_rounded,
                            'cancelled' => Icons.free_cancellation_rounded,
                            'timeout' => Icons.timer,
                            _ => Icons.help_outline,
                          },
                          stusColor: switch (
                              booking.booking.status.toLowerCase()) {
                            'completed' => AppPalette.greenColor,
                            'pending' => AppPalette.orengeColor,
                            'cancelled' => AppPalette.redColor,
                            'timeout' => AppPalette.blueColor,
                            _ => AppPalette.hintColor,
                          }
                          );
                    },
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight50(context),
                      Icon(
                        Icons.cloud_off_outlined,
                        color: AppPalette.blackColor,
                        size: 50,
                      ),
                      Text("Unable to complete the request."),
                      Text('Please try again later.'),
                      IconButton(
                          onPressed: () {
                            context
                                .read<FetchBookingWithBarberBloc>()
                                .add(FetchBookingWithBarberRequest());
                          },
                          icon: Icon(Icons.refresh_rounded))
                    ],
                  ),
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

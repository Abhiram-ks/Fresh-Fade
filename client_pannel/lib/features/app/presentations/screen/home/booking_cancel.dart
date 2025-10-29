import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/data/repo/calcel_booking_repository.dart';
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/cancel_booking_bloc/cancel_booking_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/auto_complted_booking_cubit/auto_completed_booking_cubit.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/common/custom_appbar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/di/di.dart';
import '../../widget/cancel_widget/cancel_body_widget.dart';
import '../settings/my_booking_detail_screen/my_booking_detail_screen.dart';

class CancelBookingScreen extends StatelessWidget {
  final BookingEntity booking;
  const CancelBookingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  AutoComplitedBookingCubit(CancelBookingRepositoryImpl()),
        ),
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => sl<CancelBookingBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = MediaQuery.of(context).size.height;
          double screenWidth = MediaQuery.of(context).size.width;

          return SafeArea(
            child: Scaffold(
              appBar: const CustomAppBar2(
                title: 'Booking Cancellation',
                isTitle: true,
                backgroundColor: AppPalette.whiteColor,
                iconColor: AppPalette.blackColor,
                titleColor: AppPalette.blackColor,
              ),
              body:GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      padding:    EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                        ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Cancellation',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                          const Text(
                            'Almost there! Please enter your booking Code below. If the entered Code matches the booking Code, your booking will be automatically cancelled. The refund will then be credited to your wallet shortly.',
                            style: TextStyle(fontSize: 12),
                          ),
                          ConstantWidgets.hight10(context),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MyBookingDetailScreen(
                                        docId: booking.bookingId!,
                                        barberId: booking.barberId,
                                        userId: booking.userId,
                                      ),
                                ),
                              );
                            },
                            child: Text(
                              "Booking Details",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                color: AppPalette.orengeColor,
                              ),
                            ),
                          ),
                          ConstantWidgets.hight20(context),
                          BookingCalcelOtpFiled(
                            booking: booking,
                            screenHight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

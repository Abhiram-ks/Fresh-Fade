import 'package:client_pannel/core/common/custom_appbar.dart';
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/bloc/fetch_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import '../../../widget/my_booking_widget/my_booking_body_widget.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FetchBookingWithBarberBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            appBar: CustomAppBar2(
              title: 'My Bookings History',
              isTitle: true,
              backgroundColor: AppPalette.whiteColor,
              iconColor: AppPalette.blackColor,
              titleColor: AppPalette.blackColor,
            ),
            body:MyBookingWidgets(screenWidth: screenWidth, screenHeight: screenHeight),
          );
        }
      ),
    );
  }
}

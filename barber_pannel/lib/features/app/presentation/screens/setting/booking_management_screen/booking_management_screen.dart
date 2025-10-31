import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/my_booking_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection_contains.dart';
import '../../../state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';

class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FetchBookingWithUserBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(
                title: 'Booking Management',
                isTitle: true,
                backgroundColor: AppPalette.whiteColor,
                titleColor: AppPalette.blackColor,
              ),
              body: BookingScreenWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}

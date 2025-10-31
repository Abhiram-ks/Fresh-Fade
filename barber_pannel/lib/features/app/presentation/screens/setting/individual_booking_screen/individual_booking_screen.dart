import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_individual_user_booking_bloc/fetch_individual_user_booking_bloc.dart' show FetchIndividualUserBookingBloc;
import 'package:barber_pannel/features/app/presentation/widget/individual_booking_widget/individual_booking_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndivitualBookingScreen extends StatelessWidget {
  final String userId;
  const IndivitualBookingScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return 
    BlocProvider(
      create: (context) => sl<FetchIndividualUserBookingBloc>(),
      child: 
      LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(
                title: 'Booking Overview',
                isTitle: true,
                backgroundColor: AppPalette.whiteColor,
                titleColor: AppPalette.blackColor,
                iconColor: AppPalette.blackColor,
              ),
              body: IndivitualBookingBodyWidget(
                userId: userId,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

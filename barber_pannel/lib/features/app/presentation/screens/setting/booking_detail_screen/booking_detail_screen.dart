import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detail_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection_contains.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String barberId;
  final String userId;
  final String docId;
  const BookingDetailsScreen(
      {super.key,
      required this.barberId,
      required this.userId,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchUserBloc>()),
        BlocProvider(create: (context) => sl<FetchSpecificBookingBloc>()),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(title: 'Booking Details', isTitle: true, backgroundColor: AppPalette.whiteColor, titleColor: AppPalette.blackColor, iconColor: AppPalette.blackColor,),
             body: BookingDetailBodyWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  userId: userId,
                  docId: docId,
                  barberId: barberId),
            ),
      
        );
      }),
    );
  }
}

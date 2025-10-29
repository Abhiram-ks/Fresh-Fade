import 'package:client_pannel/core/common/custom_appbar.dart';
import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/payment_widget/payment_top_portion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/di.dart';
import '../../../widget/my_booking_detail_widget/my_booking_detail_body_widget.dart';

class MyBookingDetailScreen extends StatelessWidget {
  final String docId;
  final String barberId;
  final String userId;
  const MyBookingDetailScreen({
    super.key,
    required this.docId,
    required this.barberId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchSpecificBookingBloc>()),
        BlocProvider(create: (context) => sl<FetchAbarberBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            backgroundColor: AppPalette.orengeColor,
            
            appBar: CustomAppBar2(
              title: 'Booking Details',
              isTitle: true,
              backgroundColor: AppPalette.orengeColor,
              iconColor: AppPalette.whiteColor,
              titleColor: AppPalette.whiteColor,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ConstantWidgets.hight20(context),
                  PaymentTopPortion(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    barberUId: barberId,
                  ),
                  ConstantWidgets.hight30(context),
                  MyBookingDetailScreenWidget(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    userId: userId,
                    bookingId: docId,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

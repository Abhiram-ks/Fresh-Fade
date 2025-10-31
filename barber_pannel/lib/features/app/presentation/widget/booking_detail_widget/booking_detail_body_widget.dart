import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detail_bottom_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detail_top_portion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailBodyWidget extends StatefulWidget {
  const BookingDetailBodyWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberId,
    required this.userId,
    required this.docId,
  });

  final double screenHeight;
  final double screenWidth;
  final String userId;
  final String docId;
  final String barberId;

  @override
  State<BookingDetailBodyWidget> createState() =>
      _BookingDetailBodyWidgetState();
}

class _BookingDetailBodyWidgetState extends State<BookingDetailBodyWidget> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchUserBloc>().add(FetchUserRequest(userId: widget.userId));
       context.read<FetchSpecificBookingBloc>().add(FetchSpecificBookingRequested(docId: widget.docId));
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child:  Column(
        children: [
          ConstantWidgets.hight20(context),
          TopPortionWidget(
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            userId: widget.userId,
          ),ConstantWidgets.hight20(context),
          BookingDetailsBottomDetails(screenHeight: widget.screenHeight, screenWidth:widget.screenWidth)
        ],
      ),
    );
  }
}
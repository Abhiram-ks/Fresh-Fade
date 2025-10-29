
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/my_booking_detail_widget/my_booking_detail_lists_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/constant.dart';

class MyBookingDetailScreenWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  final String bookingId;

  const MyBookingDetailScreenWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.userId,
    required this.bookingId,
  });

  @override
  State<MyBookingDetailScreenWidget> createState() =>
      _MyBookingDetailScreenWidgetState();
}

class _MyBookingDetailScreenWidgetState
    extends State<MyBookingDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchSpecificBookingBloc>()
          .add(FetchSpecificBookingRequested(bookingId: widget.bookingId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSpecificBookingBloc, FetchSpecificBookingState>(
      builder: (context, state) {
        if (state is FetchSpecificBookingLoading) {
          return  Center(child: CircularProgressIndicator(color: AppPalette.orengeColor,));
        } else if (state is FetchSpecificBookingLoaded) {
          return MyBookingDetailsScreenListsWidget(
            screenHight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            model: state.booking,
          );
        } 
           return Container(
             width: widget.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Icon(CupertinoIcons.calendar_badge_minus),
              Text('Something went wrong while processing booking request.'),
              Text( 'Please try again later.',style: TextStyle(color: AppPalette.redColor),),
              ConstantWidgets.hight20(context),
            ],
          ),
          );
        
      },
    );
  }
}


import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detail_widget_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailsBottomDetails extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const BookingDetailsBottomDetails({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<FetchSpecificBookingBloc, FetchSpecificBookingState>(
      builder: (context, state) {
        if (state is FetchSpecificBookingLoading) {
            return Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppPalette.buttonColor,
                backgroundColor: AppPalette.hintColor,
                strokeWidth: 2,
              ),
            )
          );
        } 
       else if (state is FetchSpecificBookingSuccess) {
          return MyBookingDetailsScreenListsWidget(
            screenHight: screenHeight,
            screenWidth: screenWidth,
            model: state.booking,
          );
       } 
          return Container(
             width: screenWidth,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstantWidgets.hight50(context),
                Icon(CupertinoIcons.cloud_download_fill),
                Text("Oop's Unable to complete the request."),
                Text('Please try again later.'),
                ConstantWidgets.hight20(context),
              ],
            ),
          ),
          );
        
      },
    );
  }
}





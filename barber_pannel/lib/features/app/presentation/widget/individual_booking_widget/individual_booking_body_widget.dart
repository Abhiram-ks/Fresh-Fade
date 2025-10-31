import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_individual_user_booking_bloc/fetch_individual_user_booking_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/individual_booking_widget/individual_booking_filter_card_widget.dart' show IndivitualBookingFilteringCards;
import 'package:barber_pannel/features/app/presentation/widget/individual_booking_widget/individual_booking_listbuild_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndivitualBookingBodyWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  const IndivitualBookingBodyWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.userId});

  @override
  State<IndivitualBookingBodyWidget> createState() =>
      _IndivitualBookingBodyWidgetState();
}

class _IndivitualBookingBodyWidgetState
    extends State<IndivitualBookingBodyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchIndividualUserBookingBloc>().add(FetchIndividualUserBookingRequested(userId: widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidgets.hight10(context),
              Text('Track detailed booking history and revenue insights for each customer. Monitor loyalty, frequency, and overall impact on your shop’s success.', style: TextStyle(fontSize: 12),),
              ConstantWidgets.hight20(context),
             IndivitualBookingFilteringCards(  
              userId: widget.userId,
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight,
             ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: IndivitualBookingListWidget(
              userId: widget.userId,
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}
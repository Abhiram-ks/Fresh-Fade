
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/my_booking_filter_card_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/my_booking_widget/my_booking_list_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingScreenWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const BookingScreenWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<BookingScreenWidget> createState() => _BookingScreenWidgetState();
}

class _BookingScreenWidgetState extends State<BookingScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingWithUserBloc>()
          .add(FetchBookingWithUserRequested());
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
              Text(
                'Keep full control of your appointments,  monitor booking statuses, access client details, and ensure a smooth schedule every day.',
                style: TextStyle(fontSize: 12),
              ),
              ConstantWidgets.hight20(context),
              MybookingFilteringCards(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: BookingListWIdget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}

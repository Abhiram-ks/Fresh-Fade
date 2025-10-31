
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/notfication_widget/notification_builder_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/notfication_widget/notification_filter_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifcationScreenWidget extends StatefulWidget {
  const NotifcationScreenWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  final double screenWidth;
  final double screenHeight;

  @override
  State<NotifcationScreenWidget> createState() =>
      _NotifcationScreenWidgetState();
}

class _NotifcationScreenWidgetState extends State<NotifcationScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchBookingWithUserBloc>()
          .add(FetchBookingWithUserFilteredRequested(status: 'timeout'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidgets.hight20(context),
              Text(
                'Stay updated with important booking alerts, including pending and confirmed appointments. To complete your booking process, long-press the Timeout category. ',
                style: TextStyle(fontSize: 12),
              ),
               ConstantWidgets.hight10(context),
            ],
          ),
        ),
        Center(
          child: NotificationFilterCards(screenWidth: widget.screenWidth, screenHeight: widget.screenHeight)),
        ConstantWidgets.hight20(context),
        Expanded(
            child: notificationWidgetBuilder(
                context, widget.screenHeight, widget.screenWidth)),
      ],
    );
  }
}

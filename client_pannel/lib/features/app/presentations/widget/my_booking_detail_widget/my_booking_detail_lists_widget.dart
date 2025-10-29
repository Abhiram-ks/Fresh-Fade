
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:client_pannel/features/app/presentations/widget/my_booking_detail_widget/my_booking_detail_portion_widget.dart' show MyBookingDetailsPortionWidget;
import 'package:client_pannel/features/app/presentations/widget/payment_widget/calucation_login_widget.dart';
import 'package:flutter/material.dart';


class MyBookingDetailsScreenListsWidget extends StatelessWidget {
  final double screenWidth;
  final BookingEntity model;
  final double screenHight;
  const MyBookingDetailsScreenListsWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
     final isOnline = model.paymentMethod.toLowerCase().contains('online banking');
    final double totalServiceAmount = model.serviceType.values.fold(0.0, (sum, value) => sum + value);
    final double platformFee = calculatePlatformFee(totalServiceAmount);
    return MyBookingDetailsPortionWidget(screenWidth: screenWidth, screenHight: screenHight, model: model, isOnline: isOnline, platformFee: platformFee);
  }
}

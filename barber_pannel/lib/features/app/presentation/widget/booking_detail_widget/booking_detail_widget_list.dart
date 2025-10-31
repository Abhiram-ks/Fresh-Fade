import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/booking_detailed_portion_widget.dart';
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
 
    final double totalServiceAmount = model.serviceType.values.fold(0.0, (sum, value) => sum + value);
    return MyBookingDetailsPortionWidget(screenWidth: screenWidth, screenHight: screenHight, model: model, amount: totalServiceAmount);
  }
}

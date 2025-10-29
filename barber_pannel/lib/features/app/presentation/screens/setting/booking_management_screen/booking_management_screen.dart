import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar:  CustomAppBar2(title: 'Booking Management', isTitle:  true, backgroundColor: AppPalette.whiteColor,titleColor: AppPalette.blackColor,),
      body: Column(
        children: [
          Text('Booking Management'),
        ],
      ),
      ),
    );
  }
}
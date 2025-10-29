
import 'package:client_pannel/core/common/custom_button.dart';
import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/cancel_booking_bloc/cancel_booking_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/cancel_widget/booking_cancel_state_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/cancel_widget/otp_text_form_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/launcher/launcher_service.dart';

class BookingCalcelOtpFiled extends StatefulWidget {
  const BookingCalcelOtpFiled(
      {super.key,
      required this.screenHight,
      required this.screenWidth,
      required this.booking});
  final BookingEntity booking;
  final double screenHight;
  final double screenWidth;

  @override
  State<BookingCalcelOtpFiled> createState() => _BookingCalcelOtpFiledState();
}

class _BookingCalcelOtpFiledState extends State<BookingCalcelOtpFiled> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  void onOtpChanged() {
    if (otpControllers.every((controller) => controller.text.isNotEmpty)) {
      String userOTP = getUserOTP();
      machingOTP(userOTP, context);
    }
  }

  String getUserOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void machingOTP(String userOTP, BuildContext context) async {
    final bookingOTP = widget.booking.otp;
    final bookingCancelBloc = context.read<CancelBookingBloc>();
    bookingCancelBloc.add(BookingOTPChecking(bookingOTP: bookingOTP, inputOTP: userOTP));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight50(context),
        ConstantWidgets.hight50(context),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                6,
                (index) => Opttextformfiled(
                    screenWidth: widget.screenWidth,
                    screenHight: widget.screenHight,
                    controller: otpControllers[index],
                    onChanged: (val) => onOtpChanged()))),
        ConstantWidgets.hight30(context),
        BlocListener<CancelBookingBloc, CancelBookingState>(
          listener: (context, state) {
           handleCancelBookingState(context, state, widget.booking);
          },
          child: CustomButton(text: 'Cancel Verify', onPressed: onOtpChanged),
        ),
        ConstantWidgets.hight20(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Do you know our  ", style: TextStyle(fontSize: 12)),
            InkWell(
              onTap: () {
                LauncerService.launchingFunction(
                  url:'https://www.freeprivacypolicy.com/live/eabfe916-6c9c-4b76-8aad-4bf754e803e1',
                  name: 'Service & Refund Policy',
                  context: context,
                );
              },
              child: Text(
                'cancellation policy?',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold, color: AppPalette.orengeColor),
              ),
            )
          ],
        ),
      ],
    );
  }
}

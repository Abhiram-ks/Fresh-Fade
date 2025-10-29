import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:client_pannel/features/app/presentations/widget/payment_widget/calucation_login_widget.dart';
import 'package:client_pannel/service/formalt/time_date_formalt.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/themes/app_colors.dart';
import '../widgets/clip_chip_maker_widget.dart';

class MyBookingDetailsPortionWidget extends StatelessWidget {
  const MyBookingDetailsPortionWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.model,
    required this.isOnline,
    required this.platformFee,
  });

  final double screenWidth;
  final double screenHight;
  final BookingEntity model;
  final bool isOnline;
  final double platformFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteColor),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .04, vertical: screenHight * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidgets.width20(context),
                Text('Date & time',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              "Your appointment has been successfully scheduled for ${model.slotTime.length} slot(s). Below are the date(s) and time(s):",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: model.slotTime.map((slot) {
                  final formattedDate = formatDate(slot);
                  String formattedStartTime = formatTimeRange(slot);
    
                  return ClipChipMaker.build(
                      text: '$formattedDate - $formattedStartTime',
                      actionColor: const Color.fromARGB(255, 239, 241, 246),
                      textColor: AppPalette.blackColor,
                      backgroundColor: AppPalette.whiteColor,
                      borderColor: AppPalette.hintColor,
                      onTap: () {});
                }).toList(),
              ),
            ),
            ConstantWidgets.hight10(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidgets.width20(context),
                Text('Service(s) Included',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              "${model.serviceType.length} service(s) confirmed for your appointment",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: model.serviceType.entries.map((entry) {
                  final String serviceName = entry.key;
                  final double serviceAmount = entry.value;
    
                  return ClipChipMaker.build(
                    text: '$serviceName - ₹${serviceAmount.toStringAsFixed(0)}',
                    actionColor: const Color.fromARGB(255, 239, 241, 246),
                    textColor: AppPalette.blackColor,
                    backgroundColor: AppPalette.whiteColor,
                    borderColor: AppPalette.hintColor,
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
            ConstantWidgets.hight10(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Supplementary Info',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Time Required(minutes)',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blueColor),
              suffixText: model.duration.toString(),
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Payment Method',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
              suffixText: model.paymentMethod,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
            ),  
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Payment Status',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  color: () {
                    final status = model.status.toLowerCase();
                    if (status == 'completed') return AppPalette.greenColor;
                    if (status == 'cancelled') return AppPalette.redColor;
                    if (status == 'pending') return AppPalette.orengeColor;
                  }()),
              suffixText: model.status,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Money Flow',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  color: () {
                    final status = model.transaction.toLowerCase();
                    if (status == 'credited') return AppPalette.greenColor;
                    if (status == 'debited') return AppPalette.redColor;
                  }()),
              suffixText: model.transaction,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Booking State',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  color: () {
                    final status = model.status.toLowerCase();
                    if (status == 'completed') return AppPalette.greenColor;
                    if (status == 'cancelled') return AppPalette.redColor;
                    if (status == 'pending') return AppPalette.orengeColor;
                    if (status == 'timeout') return AppPalette.blueColor;
                  }()),
              suffixText: model.status,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500, color: AppPalette.blackColor),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Booking Code',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold, color: AppPalette.blackColor),
              suffixText: model.otp,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold, color: AppPalette.blackColor),
            ),
            ConstantWidgets.hight30(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Payment summary',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight20(context),
            Column(
              children: [
                ...model.serviceType.entries.map((entry) {
                  final String serviceName = entry.key;
                  final double serviceAmount = entry.value;
    
                  return paymentSummaryTextWidget(
                    context: context,
                    prefixText: serviceName,
                    suffixText: '₹ ${serviceAmount.toStringAsFixed(0)}',
                    prefixTextStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400),
                    suffixTextStyle: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400),
                  );
                }),
                paymentSummaryTextWidget(
                  context: context,
                  prefixText: 'Platform fee(1%)',
                  prefixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.blackColor),
                  suffixText: '₹ $platformFee',
                  suffixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.blueColor),
                ),
                ConstantWidgets.hight20(context),
                Divider(color: AppPalette.hintColor),
                paymentSummaryTextWidget(
                  context: context,
                  prefixText: 'Total price',
                  prefixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.greenColor),
                  suffixText: '₹ ${model.amount.toStringAsFixed(2)}',
                  suffixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.blackColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

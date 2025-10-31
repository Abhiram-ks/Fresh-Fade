import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/domain/entity/booking_entity.dart';
import 'package:barber_pannel/features/app/presentation/widget/booking_detail_widget/clip_chip_custom_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/post_widget/post_bloc_success_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBookingDetailsPortionWidget extends StatelessWidget {
  const MyBookingDetailsPortionWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.model,
    required this.amount,
  });

  final double screenWidth;
  final double screenHight;
  final BookingEntity model;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final bool isCredited = model.transaction.toLowerCase() == 'credited';
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: AppPalette.whiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * .04,
          vertical: screenHight * .03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidgets.width20(context),
                Text(
                  'Date & time',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              "Appointment has been successfully scheduled for ${model.slotTime.length} slot(s). Below are the date(s) and time(s):",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children:
                    model.slotTime.map((slot) {
                      final formattedDate = formatDate(slot);
                      String formattedStartTime = formatTimeRange(slot);

                      return ClipChipMaker.build(
                        text: '$formattedDate - $formattedStartTime',
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
                ConstantWidgets.width20(context),
                Text(
                  'Service(s) Included',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              "${model.serviceType.length} service(s) confirmed for appointment",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children:
                    model.serviceType.entries.map((entry) {
                      final String serviceName = entry.key;
                      final double serviceAmount = entry.value;

                      return ClipChipMaker.build(
                        text:
                            '$serviceName - ₹${serviceAmount.toStringAsFixed(0)}',
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
                Text(
                  'Supplementary Info',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Time Required(minutes)',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blueColor,
              ),
              suffixText: model.duration.toString(),
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Payment Method',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
              suffixText: model.paymentMethod,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
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
                  if (status == 'timeout') return AppPalette.blueColor;
                }(),
              ),
              suffixText: model.status,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Money Flow',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: () {
                  final status = model.transaction.toLowerCase();
                  if (status == 'credited') return AppPalette.redColor;
                  if (status == 'debited') return AppPalette.greenColor;
                }(),
              ),
              suffixText: isCredited ? 'Debited' : 'Credited',
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
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
                }(),
              ),
              suffixText: model.status,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                color: AppPalette.blackColor,
              ),
            ),
            paymentSummaryTextWidget(
              context: context,
              prefixText: 'Booking Code',
              prefixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: AppPalette.blackColor,
              ),
              suffixText: model.otp,
              suffixTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                color: AppPalette.blackColor,
              ),
            ),

            ConstantWidgets.hight30(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment summary',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                      fontWeight: FontWeight.w400,
                    ),
                    suffixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
                ConstantWidgets.hight20(context),
                Divider(color: AppPalette.hintColor),
                paymentSummaryTextWidget(
                  context: context,
                  prefixText: 'Total price',
                  prefixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500,
                    color: () {
                      final status = model.status.toLowerCase();
                      if (status == 'completed') return AppPalette.greenColor;
                      if (status == 'cancelled') return AppPalette.redColor;
                      if (status == 'pending') return AppPalette.orengeColor;
                      if (status == 'timeout') return AppPalette.blueColor;
                    }(),
                  ),
                  suffixText: '₹ ${amount.toStringAsFixed(2)}',
                  suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500,
                    color: AppPalette.blackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

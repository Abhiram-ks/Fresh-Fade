import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/data/model/slot_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/common/custom_appbar.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../widget/payment_widget/calucation_login_widget.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String totalAmount;
  final String barberUid;
  final List<Map<String, dynamic>> selectedServices;
  final List<SlotModel> selectedSlots;
  final double platformFee;
  final double totalInINR;

  const PaymentSummaryScreen({
    super.key,
    required this.totalAmount,
    required this.barberUid,
    required this.selectedServices,
    required this.selectedSlots,
    required this.platformFee,
    required this.totalInINR,
  });

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Navigator.of(context).popUntil((route) {
                return route.settings.name ==
                        AppRoutes.booking + widget.barberUid ||
                    route.isFirst;
              });
            }
          },
          child: Scaffold(
            backgroundColor: AppPalette.greenColor,
            appBar: CustomAppBar2(
              isTitle: true,
              title: 'Booking Successful',
              titleColor: AppPalette.whiteColor,
              backgroundColor: AppPalette.greenColor,
              iconColor: AppPalette.whiteColor,
            ),

            body: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppPalette.greenColor,
                            AppPalette.greenColor.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          ConstantWidgets.hight20(context),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppPalette.whiteColor.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.verified,
                                color: AppPalette.whiteColor,
                                size: 70,
                              ),
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                          Text(
                            'Booking Successful!',
                            style: TextStyle(
                              color: AppPalette.whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${(double.parse(widget.totalAmount) + widget.platformFee).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppPalette.whiteColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppPalette.whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ConstantWidgets.hight10(context),
                              PaymentSuccessTopsection(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                label: widget.totalAmount,
                                barberUid: widget.barberUid,
                                selectedServices: widget.selectedServices,
                              ),
                              ConstantWidgets.hight30(context),

                              // Support Section
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * .05,
                                ),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppPalette.greenColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.support_agent_rounded,
                                      color: AppPalette.greenColor,
                                      size: 32,
                                    ),
                                    Text(
                                      'Need Help?',
                                      style: TextStyle(
                                        color: AppPalette.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: AppPalette.blackColor,
                                          fontSize: 11,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'For any queries, contact us at\n',
                                          ),
                                          TextSpan(
                                            text:
                                                'freshfade.growblic@gmail.com',
                                            style: TextStyle(
                                              color: AppPalette.greenColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            recognizer:
                                                TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launchUrl(
                                                      Uri.parse(
                                                        'mailto:freshfade.growblic@gmail.com',
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ConstantWidgets.hight30(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PaymentSuccessTopsection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String barberUid;
  final String label;
  final List<Map<String, dynamic>> selectedServices;

  const PaymentSuccessTopsection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberUid,
    required this.selectedServices,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    final double totalAmount = getTotalServiceAmount(selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Details',
                        style: TextStyle(
                          color: AppPalette.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppPalette.greenColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppPalette.greenColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: AppPalette.greenColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ConstantWidgets.hight10(context),
              Divider(),
              _buildInfoRow(
                context,
                icon: Icons.payment_rounded,
                label: 'Payment Method',
                value: 'Cash on Delivery',
                valueColor: AppPalette.greenColor,
              ),
              Divider(),
              ConstantWidgets.hight10(context),
              Text(
                'Services Booked',
                style: TextStyle(
                  color: AppPalette.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...selectedServices.map((service) {
                final String serviceName = service['serviceName'];
                final double serviceAmount = service['serviceAmount'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppPalette.greenColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.content_cut_rounded,
                          size: 18,
                          color: AppPalette.greenColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serviceName,
                          style: TextStyle(
                            color: AppPalette.blackColor,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${serviceAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppPalette.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Platform Fee (1%)',
                    style: TextStyle(color: AppPalette.blueColor, fontSize: 12),
                  ),
                  Text(
                    '₹${platformFee.toStringAsFixed(2)}',
                    style: TextStyle(color: AppPalette.blackColor, fontSize: 12,fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              ConstantWidgets.hight10(context),
              Divider(),

              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${(totalAmount + platformFee).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppPalette.greenColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppPalette.greenColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppPalette.greenColor),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(  
            label,
            style: TextStyle(color: AppPalette.blackColor, fontSize: 12),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppPalette.blackColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

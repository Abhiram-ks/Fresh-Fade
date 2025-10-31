import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/notfication_widget/notification_body_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../state/bloc/booking_status_update_bloc/booking_status_update_bloc.dart';

class NotifcationScreen extends StatelessWidget {
  const NotifcationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchBookingWithUserBloc>()),
        BlocProvider(create: (context) => sl<BookingStatusUpdateBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(
                title: 'Notifications',
                isTitle: true,
                backgroundColor: AppPalette.whiteColor,
                titleColor: AppPalette.blackColor,
                iconColor: AppPalette.blackColor,
                actions: [
                  BlocBuilder<
                    FetchBookingWithUserBloc,
                    FetchBookingWithUserState
                  >(
                    builder: (context, state) {
                      if (state is FetchBookingWithUserSuccess) {
                        final booking =
                            state.bookings
                                .where(
                                  (element) =>
                                      element.booking.status.toLowerCase() ==
                                      'timeout',
                                )
                                .toList();
                        if (booking.isNotEmpty) {
                          return IconButton(
                            icon: Icon(
                              Icons.check_circle_outline_rounded,
                              color: AppPalette.greenColor,
                            ),
                            onPressed: () {
                              context.read<BookingStatusUpdateBloc>().add(
                                BookingStatusUpdateRequested(
                                  docId: booking.first.booking.bookingId ?? '',
                                  barberId: booking.first.booking.barberId,
                                  isAll: true,
                                ),
                              );
                            },
                          );
                        }
                        return SizedBox.shrink();
                      } return SizedBox.shrink();
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder:
                            (_) => CupertinoAlertDialog(
                              title: Text('About Notifications'),
                              content: Text(
                                'Notifications provide updates about new bookings, upcoming appointments, and other important information. \n\nTimeout category is used to complete your booking process. Long-press Timeout to mark your booking as completed.',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Got it',
                                    style: TextStyle(
                                      color: AppPalette.buttonColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: Icon(
                      Icons.help_outline_outlined,
                      color: AppPalette.blackColor,
                    ),
                  ),
                ],
              ),
              body: NotifcationScreenWidget(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}

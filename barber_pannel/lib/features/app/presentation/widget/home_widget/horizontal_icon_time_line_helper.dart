import 'package:barber_pannel/features/app/presentation/widget/home_widget/horizontal_icon_timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../state/cubit/auto_complite_booking_cubit/auto_complite_booking_cubit.dart';
import '../../state/cubit/time_line_cubit/time_line_cubit.dart';

class HorizontalIconTimelineHelper extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTapInformation;
  final VoidCallback onTapCall;
  final VoidCallback onSendMail;
  final String imageUrl;
  final VoidCallback onTapUSer;
  final String userName;
  final String email;
  final String address;
  final DateTime createdAt;
  final String bookingId;
  final List<DateTime> slotTimes;
  final int duration;

  const HorizontalIconTimelineHelper({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTapInformation,
    required this.onTapCall,
    required this.onSendMail,
    required this.imageUrl,
    required this.onTapUSer,
    required this.userName,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.slotTimes,
    required this.duration,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TimelineCubit()..updateTimeline(createdAt: createdAt,slotTimes: slotTimes,duration: duration ),
        ),
        BlocProvider(create: (_) => sl<AutoComplitedBookingCubit>())
      ],
      child: HorizontalIconTimeline(
          bookingId: bookingId,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          onTapInformation: onTapInformation,
          onTapCall: onTapCall,
          onSendMail: onSendMail,
          imageUrl: imageUrl,
          onTapUSer: onTapUSer,
          userName: userName,
          email: email,
          address: address,
          createdAt: createdAt,
          slotTimes: slotTimes,
          duration: duration),
    );
  }
}

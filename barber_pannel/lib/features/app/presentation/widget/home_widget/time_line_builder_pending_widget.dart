
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/constant/constant.dart' show ConstantWidgets;
import 'package:barber_pannel/features/app/presentation/screens/chat/user_detail_view.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/booking_detail_screen/booking_detail_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/service/call/call_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/images/app_image.dart';
import '../../../../../core/themes/app_colors.dart';
import 'horizontal_icon_time_line_helper.dart';

class TimelineBuilderPendings extends StatelessWidget {
  const TimelineBuilderPendings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBookingWithUserBloc, FetchBookingWithUserState>(
      builder: (context, state) {
        if (state is FetchBookingWithUserLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.greyColor,
            highlightColor: AppPalette.whiteColor,
            child: HorizontalIconTimelineHelper(
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              createdAt: DateTime.parse('2025-05-05T15:10:38+05:30'),
              duration: 90,
              bookingId: '',
              slotTimes: [
                DateTime.parse('2025-05-12T08:00:00+05:30'),
                DateTime.parse('2025-05-12T08:45:00+05:30'),
              ],
              onTapInformation: () {},
              onTapCall: () {},
              onSendMail: () {},
              imageUrl: AppImages.appLogo,
              onTapUSer: () {},
              email: 'example@gmail.com',
              userName: 'Masterpiece - The Classic Cut Barbershop',
              address:'123 Kingsway Avenue, Downtown District, Springfield, IL 62704',
            ),
          );
        } else if (state is FetchBookingWithUserEmpty) {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstantWidgets.hight30(context),
                  Icon(Icons.event_busy),
                  Text('No Bookings Yet!',style: TextStyle(color: AppPalette.buttonColor)),
                  Text("No activity found — time to take action!"),
                  ConstantWidgets.hight30(context),
                ]),
          );
        } else if (state is FetchBookingWithUserSuccess) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: state.bookings.length,
            separatorBuilder: (_, __) =>  ConstantWidgets.hight10(context),
            itemBuilder: (context, index) {
              final booking = state.bookings[index];
              return HorizontalIconTimelineHelper(
                screenWidth: MediaQuery.of(context).size.width,
                screenHeight: MediaQuery.of(context).size.height,
                createdAt: booking.booking.createdAt,
                duration: booking.booking.duration,
                slotTimes: booking.booking.slotTime,
                bookingId: booking.booking.bookingId ?? '',
                email: booking.user.email,
                onTapInformation: () {
                  Navigator.push(
                      context,MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(
                              barberId: booking.booking.barberId,
                              userId: booking.booking.userId,
                              docId:booking.booking.bookingId ?? '')));
                },
                onTapCall: () {
                  if (booking.user.phone == null) {
                    CustomSnackBar.show(context, message: 'Phone number not available', backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
                    return;
                  } else {
                    CallHelper.makeCall(booking.user.phone ?? '', context);
                  }
                },
                onSendMail: () async {
                  final Uri emialUri = Uri(
                    scheme: 'mailto',
                    path: booking.user.email,
                    query:'subject=${Uri.encodeComponent("To connect with")}&body=${Uri.encodeComponent("Hello ${booking.user.name},\n\nI This is 'Shop Name' from Cavalog. I wanted to follow up regarding your recent booking.")}',
                  );
                  try {
                    await launchUrl(emialUri);
                  } catch (e) {
                    if (!context.mounted) return;
                    CustomSnackBar.show(context, message: 'Unable to open the email at this time.', backgroundColor: AppPalette.redColor, textAlign: TextAlign.center);
                  }
                },
                imageUrl: booking.user.photoUrl ,
                onTapUSer: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute( builder: (context) => UserProfileScreen(userId: booking.booking.userId)));
                },
                userName: booking.user.name,
                address: booking.user.address ?? 'Unknown Address',
              );
            },
          );
        }
        return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstantWidgets.hight30(context),
                Text('Something went wrong!',style: TextStyle(fontWeight: FontWeight.bold)),
                Text("We're having trouble processing your request.",style: TextStyle(fontSize: 12)),
                IconButton(onPressed: (){
                  context.read<FetchBookingWithUserBloc>().add(FetchBookingWithUserFilteredRequested(status: 'pending'));
                }, icon: Icon(CupertinoIcons.refresh)),
              ]),
        );
      },
    );
  }
}
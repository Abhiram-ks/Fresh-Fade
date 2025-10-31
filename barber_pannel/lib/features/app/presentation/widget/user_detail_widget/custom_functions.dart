import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/routes/routes.dart';
import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import 'package:barber_pannel/service/call/call_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../screens/setting/setting_screen.dart';
import '../../state/bloc/lauch_service_bloc/lauch_service_bloc.dart';

Padding customerFunctions({
  required BuildContext context,
  required double screenWidth,
  required String barberID,
  required UserEntity user,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        detailsPageActions(
          context: context,
          screenWidth: screenWidth,
          icon: CupertinoIcons.chat_bubble_2_fill,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.chatWindows,
              arguments: {'userId': user.id, 'barberId': barberID},
            );
          },
          text: 'Message',
        ),
        detailsPageActions(
          context: context,
          screenWidth: screenWidth,
          icon: Icons.phone_in_talk_rounded,
          onTap: () {
            if (user.phone == null || user.phone!.isEmpty) {
              CustomSnackBar.show(
                context,
                message: "Phone number not available at that moment",
                textAlign: TextAlign.center,
                backgroundColor: AppPalette.redColor,
              );
              return;
            } else {
              CallHelper.makeCall(user.phone ?? '', context);
            }
          },
          text: 'Call',
        ),
        BlocListener<LauchServiceBloc, LauchServiceState>(
          listener: (context, state) {
            handleEmailLaucher(context, state);
          },
          child: detailsPageActions(
            context: context,
            screenWidth: screenWidth,
            icon: Icons.attach_email,
            onTap: () async {
              context.read<LauchServiceBloc>().add(
                LauchServiceAlertBoxEvent(
                  name: user.name,
                  email: user.email,
                  subject: "To connect with ${user.name}",
                  body: 'I wanted to follow up regarding your recent booking.',
                ),
              );
            },
            text: 'Email',
          ),
        ),
  
          detailsPageActions(
            context: context,
            colors: AppPalette.buttonColor,
            screenWidth: screenWidth,
            icon: CupertinoIcons.calendar,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.individualBooking, arguments:  user.id);
            },
            text: 'Bookings',
          ),
      ],
    ),
  );
}

void handleEmailLaucher(BuildContext context, LauchServiceState state) {
  if (state is LauchServiceAlertBox) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Please confirm the session',
      message:
          'Are you sure you want to launch the email? Yes? confirm else declired that activity',
      onTap: () {
        context.read<LauchServiceBloc>().add(LauchServiceConfirmEvent());
      },
      firstButtonColor: AppPalette.buttonColor,
      firstButtonText: 'Confirm',
      secondButtonText: 'Decline',
      secondButtonColor: AppPalette.blackColor,
    );
  } else if (state is LauchServiceAlertBoxSuccess) {
    CustomSnackBar.show(
      context,
      message: 'Email launched successfully',
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.greenColor,
    );
  } else if (state is LauchServiceAlertBoxError) {
    CustomSnackBar.show(
      context,
      message: state.error,
      textAlign: TextAlign.center,
      backgroundColor: AppPalette.redColor,
    );
  } else if (state is LauchServiceLoading) {
    CustomSnackBar.show(
      context,
      message: 'Email launching in progress.',
      textAlign: TextAlign.center,
    );
  }
}

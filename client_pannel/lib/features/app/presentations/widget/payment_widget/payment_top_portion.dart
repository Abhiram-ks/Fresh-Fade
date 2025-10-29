import 'dart:ui';
import 'package:client_pannel/core/routes/routes.dart';
import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/widgets/custom_cards_payments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/images/app_images.dart';

class PaymentTopPortion extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String barberUId;
  const PaymentTopPortion(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.barberUId});

  @override
  State<PaymentTopPortion> createState() => _PaymentTopPortionState();
}

class _PaymentTopPortionState extends State<PaymentTopPortion> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchAbarberBloc>()
          .add(FetchABarberEventRequest(barberId: widget.barberUId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      children: [
        Center(child: BlocBuilder<FetchAbarberBloc, FetchAbarberState>(
          builder: (context, state) {
            if (state is FetchABarberSuccess) {
              final barber = state.barber;
              return ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        height: widget.screenHeight * 0.13,
                        width: widget.screenWidth * 0.77,
                        color: AppPalette.blackColor.withAlpha((0.27 * 205).toInt()),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.detailBarber, arguments: barber.uid),
                          child: paymentSectionBarberData(
                              context: context,
                              locationClr: AppPalette.whiteColor,
                              imageURl: barber.image ?? AppImages.barberEmpty,
                              shopName: barber.ventureName,
                              shopAddress: barber.address,
                              ratings: barber.rating ,
                              screenHeight: widget.screenHeight,
                              screenWidth: widget.screenWidth),
                        ),
                      )));
            }
            return Shimmer.fromColors(
                baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                highlightColor: AppPalette.whiteColor,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        height: widget.screenHeight * 0.13,
                        width: widget.screenWidth * 0.77,
                        color: AppPalette.hintColor.withAlpha((0.5 * 255).toInt()),
                        alignment: Alignment.center,
                        child: paymentSectionBarberData(
                            context: context,
                            imageURl: AppImages.barberEmpty,
                            shopName: 'Automatic trading mechanics',
                            shopAddress:'Ambalawayal sulthan bathery eranakulam',
                            ratings: 3,
                            screenHeight: widget.screenHeight,
                            screenWidth: widget.screenWidth),
                      ),
                    )));
          },
        ))
      ],
    );
  }
}
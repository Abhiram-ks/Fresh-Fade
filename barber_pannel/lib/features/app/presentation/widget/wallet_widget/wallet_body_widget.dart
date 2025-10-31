import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_booking_with_user_bloc/fetch_booking_with_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/wallet_widget/wallet_bloc_builder_widget.dart';
import 'package:barber_pannel/features/app/presentation/widget/wallet_widget/wallet_filter_cards_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'wallet_overview_card_widget.dart';

class WalletScreenWidget extends StatefulWidget {
  const WalletScreenWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<WalletScreenWidget> createState() => _WalletScreenWidgetState();
}

class _WalletScreenWidgetState extends State<WalletScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
     context.read<FetchBookingWithUserBloc>().add(FetchBookingWithUserRequested());
      context.read<FetchWalletBloc>().add(FetchWalletEventStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth*.15 : widget.screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidgets.hight10(context),
              Text(
                'Manage your wallet effortlessly check history, monitor payments, and top up in seconds.',style: GoogleFonts.plusJakartaSans( fontSize: 12),
              ),
            ],
          ),
        ),
        WalletOverviewCard(
          screenWidth: widget.screenWidth,
          screenHeight: widget.screenHeight,
        ),
        WalletFilterCardsWidget(
          screenWidth: widget.screenWidth,
          screenHeight: widget.screenHeight,
        ),
        ConstantWidgets.hight10(context),
        Expanded(
          child: WalletBlocBuilderWidget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
        )
      ],
    );
  }
}
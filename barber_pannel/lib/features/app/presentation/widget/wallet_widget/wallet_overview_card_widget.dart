
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_wallet_bloc/fetch_wallet_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/wallet_widget/wallet_custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WalletOverviewCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const WalletOverviewCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.12,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:screenWidth > 600 ? screenWidth *.15 : screenWidth * 0.05),
        child: Column(
          children: [
            ConstantWidgets.hight10(context),
            BlocBuilder<FetchWalletBloc, FetchWalletState>(
              builder: (context, state) {
                if (state is FetchWalletLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                    highlightColor: AppPalette.whiteColor,
                    child: walletBalanceWidget(
                      iconColor: AppPalette.greyColor,
                      context: context,
                      balance: 'Loading...',
                      balanceColor: AppPalette.greyColor,
                    ),
                  );
                } else if(state is FetchWalletLoaded) {
                  final double amount = state.amount;
                  final bool balance = amount < 1000;

                  return walletBalanceWidget(
                    iconColor: balance
                        ? AppPalette.redColor
                        : AppPalette.buttonColor,
                    context: context,
                    balance: '₹ ${amount.toStringAsFixed(2)}',
                    balanceColor: balance
                        ? AppPalette.redColor
                        : AppPalette.buttonColor,
                  );
                  
                }
                return walletBalanceWidget(
                    iconColor: AppPalette.blackColor,
                    context: context,
                    balance: '₹ 0.00',
                    balanceColor: AppPalette.blackColor);
              },
            ),
            ConstantWidgets.hight10(context),
          ],
        ),
      ),
    );
  }
}

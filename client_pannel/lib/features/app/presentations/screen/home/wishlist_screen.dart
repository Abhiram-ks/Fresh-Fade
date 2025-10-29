
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/common/custom_appbar.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/di/di.dart';
import '../../state/bloc/fetch_bloc/fetch_wishlist_bloc/fetch_wishlist_bloc.dart';
import '../../widget/wishlist_widget/wishlist_body_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FetchWishlistBloc>(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
              child: Scaffold(
            appBar: CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Top Picks", style: GoogleFonts.plusJakartaSans( fontSize: 28, fontWeight: FontWeight.bold)),
                      ConstantWidgets.hight10(context),
                      Text( 'Keep track of your favorite barbershops — browse your top picks, revisit saved spots, and book again with ease.'),
                      ConstantWidgets.hight20(context)
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: WishlistScreenWidget(
                      screenHeight: screenHeight, screenWidth: screenWidth),
                )))
              ],
            ),
          ));
        },
      ),
    );
  }
}
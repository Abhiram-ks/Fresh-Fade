
import 'package:admin_pannel/core/constant/constant.dart';
import 'package:admin_pannel/features/presentation/state/bloc/toggleview_bloc/toggleview_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/dashbord_widget/dashboard_filters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdministrationScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const AdministrationScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal:screenWidth > 600 ? screenWidth * .2: screenWidth * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstantWidgets.hight10(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardFilters(message: 'Manage Bookings', icon: CupertinoIcons.calendar,action: (){
                 
                },),
                DashboardFilters(message: 'Wallet Configuration', icon: Icons.account_balance_wallet,action: (){
                  
                },),
                DashboardFilters(message: 'Administration Enquiries', icon: Icons.person_search,action: (){
                  context.read<ToggleviewBloc>().add(ToggleviewAction()); 
                },),
              ],
            ),
            ConstantWidgets.hight10(context),
            BlocBuilder<ToggleviewBloc, ToggleviewState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state is ToggleviewStatus ? 'Administration Status' : 'Administration Requests',
                    style:  GoogleFonts.bellefair(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
            // Expanded(
            //   child: BlocBuilder<ToggleviewBloc, ToggleviewState>(
            //     builder: (context, state) {
            //       return state is ToggleviewStatus
            //           ? BarbersStatusBuilder(
            //               screenHeight: screenHeight, screenWidth: screenWidth)
            //           : RequstBlocBuilder(
            //               screenHeight: screenHeight, screenWidth: screenWidth);
            //     },
            //   ),
            // )
          ],
        ),
      );
    });
  }
}

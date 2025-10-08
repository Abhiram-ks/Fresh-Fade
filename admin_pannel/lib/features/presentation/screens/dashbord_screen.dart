import 'package:admin_pannel/core/themes/app_colors.dart';
import 'package:admin_pannel/features/presentation/screens/dashbord_screen/administration.dart';
import 'package:admin_pannel/features/presentation/screens/dashbord_screen/promotion.dart';
import 'package:admin_pannel/features/presentation/screens/dashbord_screen/service.dart';
import 'package:admin_pannel/features/presentation/state/bloc/toggleview_bloc/toggleview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../../data/datasource/auth_local_datasource.dart';
import '../state/bloc/logout_bloc/logout_bloc.dart';
import '../widgets/dashbord_widget/custom_tabbars.dart';

class DashbordScreen extends StatelessWidget {
  const DashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ToggleviewBloc()),
        BlocProvider(create: (context) => LogoutBloc(authLocalDatasource: sl<AuthLocalDatasource>())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: TabBarCustom(screenWidth: screenWidth),
                  body: SafeArea(
                    child: TabBarView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        AdministrationScreen(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        ),
                        ServiceScreen(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        ),
                        PromotionScreen(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

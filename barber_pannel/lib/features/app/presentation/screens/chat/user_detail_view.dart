import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/common/custom_appbar2.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../../state/bloc/lauch_service_bloc/lauch_service_bloc.dart';
import '../../widget/user_detail_widget/user_widget_body.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchUserBloc>()),
        BlocProvider(create: (context) => sl<LauchServiceBloc>()),
      ],
     child:
    LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar2(
                    isTitle: true,
                    title: 'Profile Details',
                  ),
                  body:   UserProfileBodyWIdget(
                      userId: userId,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight)
                      
              ));
        },
      ),
    );
  }
}

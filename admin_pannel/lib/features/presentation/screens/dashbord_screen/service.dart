
import 'package:admin_pannel/core/di/service_locator.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/service_widget/service_upload_widget.dart';

class ServiceScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ServiceScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchingServiceBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  screenWidth > 600 ? screenWidth * .2 : screenWidth * 0.05,
            ),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: BouncingScrollPhysics(),
                child: UploadServicesWidget(
                  screenHight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}






import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/common/custom_button.dart';
import '../../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../../state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import '../../../state/bloc/fetch_bloc/fetch_barber_post_bloc/fetch_barber_post_bloc.dart';
import '../../../widget/detail_widget/detail_body_widget.dart';

class DetailBarberScreen extends StatelessWidget {
  final String barberID;

  const DetailBarberScreen({super.key, required this.barberID});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchAbarberBloc>()),
        BlocProvider(create: (context) => sl<FetchBarberServiceBloc>()),
        BlocProvider(create: (context) => sl<FetchBarberPostBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            body: DetailScreenWidgetBuilder(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              barberId: barberID,
            ),
            floatingActionButton: SizedBox(
              height: 45,
              child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.09),
                  child: CustomButton(
                    text: 'Booking Now',
                      onPressed: (){},
              
                  ),
                ),
            ),
          );
        },
      ),
    );
  }
}

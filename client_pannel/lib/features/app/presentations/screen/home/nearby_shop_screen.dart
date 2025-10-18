import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/narby_barbershop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/repo/barbershop_repo_impl.dart';
import '../../../domain/usecase/get_location_usecase.dart';
import '../../state/bloc/location_bloc/location_bloc.dart';
import '../../state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../state/bloc/search_location_bloc/searchlocation_bloc.dart';
import '../../state/cubit/distance_filter_cubit/distance_cubit.dart';

class NearbyBarbershopScreen extends StatelessWidget {
  final LatLng currentPosition;

  const NearbyBarbershopScreen({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchInputCubit()),
        BlocProvider(create: (_) => SerchlocatonBloc()),
        BlocProvider(create: (context) => DistanceFilterCubit()),
        BlocProvider(create: (context) => NearbyBarbersBloc(GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(create: (context) => LocationBloc(GetLocationUseCase()) ..add(GetCurrentLocationEvent())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: NearbyBarberShopScreenWidget(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                currentPosition: currentPosition),
          );
        },
      ),
    );
  }
}

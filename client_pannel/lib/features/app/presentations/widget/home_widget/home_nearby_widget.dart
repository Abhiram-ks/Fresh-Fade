import 'package:client_pannel/features/app/presentations/state/bloc/location_bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../screen/home/nearby_shop_screen.dart';
import '../../state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import 'home_screen_map_widget.dart';

class HomeScreenNearbyWIdget extends StatefulWidget {
  const HomeScreenNearbyWIdget({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  State<HomeScreenNearbyWIdget> createState() => _HomeScreenNearbyWIdgetState();
}

class _HomeScreenNearbyWIdgetState extends State<HomeScreenNearbyWIdget> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        HomeScreenMapWidget(mapController: widget.mapController),
        Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.blueColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoading) {
                    return Text(
                      'Nearby Shops: Loading...',
                      style: TextStyle(color: AppPalette.whiteColor),
                    );
                  } else if (state is NearbyBarbersLoaded) {
                    return InkWell(
                      onTap: () {},
                      child: Text(
                        'Nearby Shops: ${state.barbers.length} result(s)',
                        style: TextStyle(color: AppPalette.whiteColor),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        context
                            .read<LocationBloc>()
                            .add(GetCurrentLocationEvent());
                      },
                      child: const Text(
                        'Search... failed',
                        style: TextStyle(color: AppPalette.whiteColor),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoading) {
                    return SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppPalette.orengeColor,),
                    );
                  } 
                  else if (state is NearbyBarbersLoaded){
                       return InkWell(
                      onTap: () {},
                      child: Text(
                        'Nearby barber shops (5 km search area)',
                        style: TextStyle(color: AppPalette.blackColor),
                      ),
                    );
                  }
                    return InkWell(
                      onTap: () {
                        context.read<LocationBloc>().add(GetCurrentLocationEvent());
                      },      
                      child: Text(
                        'connection failed. Please try again.',
                        style: TextStyle(color: AppPalette.blackColor),
                      ),
                    );
                  
                },
              ),
            ),
          ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppPalette.orengeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return  Text(
                    'Loading...',
                    style: TextStyle(color: AppPalette.whiteColor),
                  );
                }
                else if (state is LocationLoaded){
                  final LatLng currentPosition = state.position;
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyBarbershopScreen(currentPosition: currentPosition)));
                  },
                  child: const Text(
                    'Find now',
                    style: TextStyle(color: AppPalette.whiteColor),
                  ),
                );
                }
                else{
                return InkWell(
                  onTap: () {
                    context.read<LocationBloc>().add(GetCurrentLocationEvent());
                  },
                  child: const Text('Retry',
                    style: TextStyle(color: AppPalette.whiteColor),
                  ),
                );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

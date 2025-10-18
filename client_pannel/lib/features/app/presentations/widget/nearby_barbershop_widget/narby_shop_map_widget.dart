import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/narby_barbershop_create_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/narby_barbershop_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/nearby_shop_search_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../../core/debouncer/debouncer.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/location_bloc/location_bloc.dart';
import '../../state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../state/cubit/distance_filter_cubit/distance_cubit.dart';
import 'narby_getdistance_meter.dart';

class NearbyShopMapWidget extends StatelessWidget {
  const NearbyShopMapWidget({
    super.key,
    required this.widget,
    required MapController mapController,
    required this.searchController,
    required this.debouncer,
  }) : _mapController = mapController;

  final NearbyBarberShopScreenWidget widget;
  final MapController _mapController;
  final TextEditingController searchController;
  final Debouncer debouncer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.screenHeight * 0.74,
      width: widget.screenWidth,
      child: Stack(
        children: [
          NearbyBarberShopCreateMapWidget(mapController: _mapController, searchController: searchController),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.orengeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationLoading) {
                    return Text(
                      'Loading...',
                      style: TextStyle(color: AppPalette.whiteColor),
                    );
                  } else if (state is LocationLoaded) {
                    return InkWell(
                      onTap: () {
                        final selectedDistance = context.read<DistanceFilterCubit>().state;
                        int distanceInMeters = getDistanceInMeters(selectedDistance);
                        context.read<NearbyBarbersBloc>().add(
                            LoadNearbyBarbers(
                                widget.currentPosition.latitude,
                                widget.currentPosition.longitude,
                                distanceInMeters));
                      },
                      child: const Text(
                        'Apply filter',
                        style: TextStyle(color: AppPalette.whiteColor),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        context.read<LocationBloc>().add(GetCurrentLocationEvent());
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: AppPalette.whiteColor),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
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
                        context.read<LocationBloc>().add(GetCurrentLocationEvent());
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
            top: 50,
            left: 10,
            right: 10,
            child: NearbyShopSearchFiledWidget(searchController: searchController, debouncer: debouncer, mapController: _mapController, screenHeight: widget.screenHeight),
          ),
        ],
      ),
    );
  }
}

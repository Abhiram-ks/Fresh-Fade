import 'package:client_pannel/features/app/presentations/state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/distance_filter_cubit/distance_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/narby_shop_map_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/nearby_shop_dropdown_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/nearby_shops_details_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/debouncer/debouncer.dart';

class NearbyBarberShopScreenWidget extends StatefulWidget {
  const NearbyBarberShopScreenWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.currentPosition});

  final double screenHeight;
  final LatLng currentPosition;
  final double screenWidth;

  @override
  State<NearbyBarberShopScreenWidget> createState() =>
      NearbyBarberShopScreenWidgetState();
}

class NearbyBarberShopScreenWidgetState
    extends State<NearbyBarberShopScreenWidget>  {
  final MapController _mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  late Debouncer debouncer = Debouncer(milliseconds: 150);

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      context.read<SearchInputCubit>().update(searchController.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearbyBarbersBloc>().add(LoadNearbyBarbers(
          widget.currentPosition.latitude,
          widget.currentPosition.longitude,
          5000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NearbyShopMapWidget(widget: widget, mapController: _mapController, searchController: searchController, debouncer: debouncer),
        nearbyShopDrpdownWIdget(context, widget.screenHeight, widget.screenWidth),
        nerbyWorkShopDetailsWIdget(screenHeight: widget.screenHeight, screenWidth: widget.screenWidth),
      ],
    );
  }
}

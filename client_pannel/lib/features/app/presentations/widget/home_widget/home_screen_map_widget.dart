import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/location_bloc/location_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/home_widget/home_create_geocircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreenMapWidget extends StatelessWidget {
  const HomeScreenMapWidget({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        if (locationState is LocationLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppPalette.orengeColor),
          );
        }
         else if (locationState is LocationLoaded) {
          final LatLng currentPosition = locationState.position;
    
          context.read<NearbyBarbersBloc>().add(
                LoadNearbyBarbers(currentPosition.latitude,currentPosition.longitude, 5000),
              );
    
          return BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
            builder: (context, barberState) {
              List<Marker> markers = [
                Marker(
                  point: currentPosition,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location,
                      color: AppPalette.redColor, size: 20),
                ),
              ];
    
              if (barberState is NearbyBarbersLoaded) {
                markers.addAll(barberState.barbers.map((barber) {
                  return Marker(
                    point: LatLng(barber.lat, barber.lng),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.content_cut, color: AppPalette.blackColor, size: 10),
                  );
                }));
              }
    
              return FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: currentPosition,
                  initialZoom: 14.5,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.yourcompany.yourapp',
                  ),
                  PolygonLayer(
                          polygons: [
                            Polygon(
                              points: createGeodesicCircle( currentPosition, 5000),
                              color: AppPalette.blueColor
                                  .withAlpha((0.2 * 255).toInt()),
                              borderColor: AppPalette.blueColor,
                              borderStrokeWidth: 1,
                            ),
                          ],
                        ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          );
        }
    
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off),
              Text('Failed to load map!',
                  style: TextStyle(color: AppPalette.redColor)),
              const Text('Unexpected error! Please try again.',style: TextStyle(fontSize: 12),),
            ],
          ),
        );
      },
    );
  }
}

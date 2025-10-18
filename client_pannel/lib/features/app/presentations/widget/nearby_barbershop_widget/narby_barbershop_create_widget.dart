import 'package:client_pannel/core/constant/constant.dart';
import 'package:client_pannel/core/images/app_images.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/distance_filter_cubit/distance_cubit.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/distance_filter_cubit/distance_state.dart';
import 'package:client_pannel/features/app/presentations/widget/home_widget/home_create_geocircle.dart';
import 'package:client_pannel/features/app/presentations/widget/nearby_barbershop_widget/narby_getdistance_meter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../state/bloc/location_bloc/location_bloc.dart';
import '../../state/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';

// Pulsing loading widget for map loading state
class PulsingMapLoadingWidget extends StatefulWidget {
  const PulsingMapLoadingWidget({super.key});

  @override
  State<PulsingMapLoadingWidget> createState() => _PulsingMapLoadingWidgetState();
}

class _PulsingMapLoadingWidgetState extends State<PulsingMapLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100 + (_animation.value * 30),
              height: 100 + (_animation.value * 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.orengeColor.withValues(alpha: 0.1 - (_animation.value * 0.1)),
              ),
            ),
            // Inner animated circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.orengeColor.withValues(alpha: 0.2),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppPalette.orengeColor,
                  strokeWidth: 3,
                ),
              ),
            ),
            // Center icon
            const Icon(
              Icons.map_rounded,
              color: AppPalette.orengeColor,
              size: 32,
            ),
          ],
        );
      },
    );
  }
}

class NearbyBarberShopCreateMapWidget extends StatelessWidget {
  const NearbyBarberShopCreateMapWidget({
    super.key,
    required MapController mapController,
    required this.searchController,
  }) : _mapController = mapController;

  final MapController _mapController;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        if (locationState is LocationLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PulsingMapLoadingWidget(),
                const SizedBox(height: 20),
                Text(
                  'Loading Map...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.whiteColor,
                  ),
                ),
              ],
            ),
          );
        }
         else if (locationState is LocationLoaded) {
          final LatLng currentPosition = locationState.position;
        
          context.read<NearbyBarbersBloc>().add(LoadNearbyBarbers(
              currentPosition.latitude,
              currentPosition.longitude,
              5000));
        
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
                    child: Icon(Icons.content_cut,
                        color: AppPalette.blackColor, size: 10),
                  );
                }));
              }
        
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentPosition,
                  initialZoom: 14.5,
                  interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all),
                  onTap: (tapPosition, point) async {
                    context
                        .read<LocationBloc>()
                        .add(UpdateLocationEvent(point));
                    try {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              point.latitude, point.longitude);
                      if (placemarks.isNotEmpty) {
                        final Placemark place = placemarks.first;
                        String formatAddress =  AddressFormatter.formatAddress(place);
                        searchController.text = formatAddress;
                      } else {
                        searchController.text =
                            "${point.latitude}, ${point.longitude}";
                      }
                    } catch (e) {
                      searchController.text =
                          "${point.latitude}, ${point.longitude}";
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.yourcompany.yourapp',
                    tileProvider: NetworkTileProvider(),
                    fallbackUrl: null,
                  ),
                  BlocBuilder<DistanceFilterCubit, DistanceFilter>(
                    builder: (context, state) {
                      final selectedDistance =  context.read<DistanceFilterCubit>().state;
                      int distanceInMeters = getDistanceInMeters(selectedDistance);
                      return PolygonLayer(
                        polygons: [
                          Polygon(
                            points: createGeodesicCircle(
                                currentPosition, distanceInMeters),
                            color: AppPalette.blueColor
                                .withAlpha((0.2 * 255).toInt()),
                            borderColor: AppPalette.blueColor,
                            borderStrokeWidth: 1,
                          ),
                        ],
                      );
                    },
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          );
        } 

        else if (locationState is LocationPermissionDenied) {
         return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                'Permission Denied!',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.redColor,
                ),
                ),
                Text(locationState.message,style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                TextButton(onPressed: () {
                  context.read<LocationBloc>().add(RequestLocationPermissionEvent());
                }, child: Text('Request Permission',style: TextStyle(color: AppPalette.blackColor),)),
              ],
            ),
          );
        }

        else if (locationState is LocationError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                'Failed to load map!',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.redColor,
                ),
                ),
                Text(locationState.message,style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(AppImages.appLogo, fit: BoxFit.cover),
              ),
              ConstantWidgets.hight20(context),
              Text(
                'Failed to load map!',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.redColor,
                ),
              ),
              Text(
                'Unexpected error! Please try again.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

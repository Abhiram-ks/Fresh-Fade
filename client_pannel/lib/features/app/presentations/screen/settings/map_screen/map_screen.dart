
import 'package:client_pannel/features/app/presentations/state/bloc/location_bloc/location_bloc.dart';
import 'package:client_pannel/service/formalt/time_date_formalt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../core/common/custom_button.dart';
import '../../../../../../core/common/custom_cupertino_dialog.dart';
import '../../../../../../core/common/custom_snackbar.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/debouncer/debouncer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../../../domain/usecase/get_location_usecase.dart';
import '../../../state/bloc/search_location_bloc/searchlocation_bloc.dart';

class LocationMapPage extends StatefulWidget {
  final TextEditingController addressController;

  const LocationMapPage({super.key, required this.addressController});

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController searchController = TextEditingController();
  final MapController _mapController = MapController();
  late Debouncer debouncer = Debouncer(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SerchlocatonBloc()),
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => LocationBloc(GetLocationUseCase())..add(GetCurrentLocationEvent())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: LocationMapWidget(
                  mapController: _mapController,
                  searchController: searchController,
                  widget: widget,
                  debouncer: debouncer,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
            ),
          );
        },
      ),
    );
  }
}

//! access permission dialog
void showPermissionDialog(BuildContext context, String message) {
  final locationBloc = context.read<LocationBloc>();

  CustomCupertinoDialog.show(
    context: context,
    title: 'Location Permission',
    message: message,
    onTap: () {
      locationBloc.add(RequestLocationPermissionEvent());  
    },
    secondButtonText: 'Cancel',
    firstButtonText: 'Grant Permission',
    firstButtonColor: AppPalette.buttonColor,
  );
}

class LocationMapWidget extends StatelessWidget {
  const LocationMapWidget({
    super.key,
    required MapController mapController,
    required this.searchController,
    required this.widget,
    required this.debouncer,
    required this.screenHeight,
    required this.screenWidth,
  }) : _mapController = mapController;

  final MapController _mapController;
  final TextEditingController searchController;
  final LocationMapPage widget;
  final Debouncer debouncer;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationPermissionDenied) {
          showPermissionDialog(context, state.message);
        }
        if (state is LocationLoaded && state.isLiveTracking) {
          _mapController.move(state.position, 16.0);
        }
      },
      child: Stack(
        children: [
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is LocationLoading) {
                               return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppPalette.buttonColor.withValues(alpha: 0.1),
                        AppPalette.whiteColor,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: AppPalette.hintColor,
                            backgroundColor: AppPalette.buttonColor,
                            strokeWidth: 2,
                          ),
                        ),
                        ConstantWidgets.hight20(context),
                        Text(
                          'Please wait while we get your location...',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'We need access to your location to provide better service.',
                          style: TextStyle(
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is LocationLoaded) {
                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: state.position,
                    onTap: (tapPosition, point) async {
                      context.read<LocationBloc>().add(
                        UpdateLocationEvent(point),
                      );
                      try {
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                              point.latitude,
                              point.longitude,
                            );
                        if (placemarks.isNotEmpty) {
                          final Placemark place = placemarks.first;
                          String formatAddress = AddressFormatter.formatAddress(
                            place,
                          );
                          searchController.text = formatAddress;
                          widget.addressController.text = formatAddress;
                        } else {
                          searchController.text =
                              "${point.latitude}, ${point.longitude}";
                          widget.addressController.text =
                              "${point.latitude}, ${point.longitude}";
                        }
                      } catch (e) {
                        searchController.text =
                            "${point.latitude}, ${point.longitude}";
                        widget.addressController.text =
                            "${point.latitude}, ${point.longitude}";
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.cavlog.app',
                      errorTileCallback: (tile, error, stackTrace) {},
                      tileProvider: NetworkTileProvider(),
                      fallbackUrl: null,
                    ),
                   if (state.isLiveTracking)
                    CircleLayer(circles: [
                      CircleMarker(
                        point: state.position,
                        color: AppPalette.buttonColor.withValues(alpha: 0.15),
                        borderColor: AppPalette.buttonColor.withValues(alpha: 0.4),
                        borderStrokeWidth: 2,
                        radius: 30,
                        useRadiusInMeter: true,
                      ),
                    ]),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: state.position,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing animation effect for live tracking
                              if (state.isLiveTracking)
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppPalette.buttonColor.withValues(alpha: 
                                      0.3,
                                    ),
                                  ),
                                ),
                               Icon(
                                  state.isLiveTracking
                                      ? Icons.my_location
                                      : Icons.location_pin,
                                  color:
                                      state.isLiveTracking
                                          ? AppPalette.buttonColor
                                          : Colors.red,
                                  size: 32,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is LocationError) {
                return Container(
                      color: AppPalette.whiteColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<LocationBloc>().add(
                                GetCurrentLocationEvent(),
                              );
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPalette.buttonColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is LocationPermissionDenied) {
                 return Container(
                   color: AppPalette.whiteColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            color: AppPalette.blackColor,
                            size: 50,
                          ),
                          Text(
                            'Location Permission Required',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<LocationBloc>().add(
                                RequestLocationPermissionEvent(),
                              );
                            },
                            icon: Icon(Icons.location_on),
                            label: Text('Grant Permission'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPalette.buttonColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                          ConstantWidgets.hight10(context),
                          Text('Otherwise, try to enable location services from your settings to access all functionalities.', style: TextStyle(fontSize: 10), textAlign: TextAlign.center,),
                          TextButton.icon(
                            onPressed: () {
                              openAppSettings();
                            },
                            icon: Icon(Icons.settings),
                            label: Text('Open Settings'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppPalette.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 64, color: AppPalette.hintColor),
                      SizedBox(height: 16),
                      Text(
                        "Tap to get location",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppPalette.hintColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location..',
                    fillColor: AppPalette.whiteColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppPalette.hintColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppPalette.hintColor,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppPalette.hintColor,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: AppPalette.blackColor,
                  ),
                  onChanged: (query) {
                    debouncer.run(() {
                      context.read<SerchlocatonBloc>().add(
                        SearchLocationEvent(query),
                      );
                    });
                  },
                ),
                BlocBuilder<SerchlocatonBloc, SerchlocatonState>(
                  builder: (context, state) {
                    if (state is SearchLocationLoaded &&
                        state.suggestions.isNotEmpty) {
                      return Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 5),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = state.suggestions[index];
                            return ListTile(
                              title: Text(suggestion['display_name']),
                              onTap: () {
                                double lat = double.parse(suggestion['lat']);
                                double lon = double.parse(suggestion['lon']);
                                searchController.text =
                                    suggestion['display_name'];
                                widget.addressController.text =
                                    suggestion['display_name'];
                                context.read<SerchlocatonBloc>().add(
                                  SelectLocationEvent(
                                    lat,
                                    lon,
                                    suggestion['display_name'],
                                  ),
                                );

                                Future.delayed(Duration(milliseconds: 300), () {
                                  _mapController.move(LatLng(lat, lon), 15.0);
                                });
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is SearchLocationError) {
                      return Container(
                        width: double.infinity,
                        height: screenHeight * .06,
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 5),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: AppPalette.hintColor),
                              ConstantWidgets.width20(context),
                              Text(
                                'Search for "${searchController.text}"',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 100,
            right: 20,
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                final isLiveTracking =
                    state is LocationLoaded && state.isLiveTracking;
                return FloatingActionButton(
                  heroTag: 'live_tracking',
                  onPressed: () {
                    if (isLiveTracking) {
                      context.read<LocationBloc>().add(StopLiveTrackingEvent());
                      CustomSnackBar.show(
                        context,
                        message: 'Live tracking stopped',
                        textAlign: TextAlign.center
                      );
                    } else {
                      context.read<LocationBloc>().add(
                        StartLiveTrackingEvent(),
                      );
                      CustomSnackBar.show(
                        context,
                        message: 'Live tracking enabled',
                        textAlign: TextAlign.center
                      );
                    }
                  },
                  backgroundColor: isLiveTracking ? AppPalette.redColor: AppPalette.redColor,
                  elevation: 6,
                  child: Icon(
                    isLiveTracking ? Icons.gps_off : Icons.my_location,
                    color: AppPalette.whiteColor,
                  ),
                );
              },
            ),
          ),

         Positioned(
            bottom: 170,
            right: 20,
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationLoaded) {
                  return FloatingActionButton(
                    heroTag: 'recenter',
                    mini: true,
                    onPressed: () {
                      _mapController.move(state.position, 15.0);
                    },
                    backgroundColor: Colors.white,
                    elevation: 4,
                    child: Icon(
                      Icons.center_focus_strong,
                      color: AppPalette.buttonColor,
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              text: 'Save Point',
              onPressed: () {
                if (widget.addressController.text.isEmpty) {
                  CustomSnackBar.show(
                    context,
                    message:
                        'Select Address! Make sure to update your address section before proceeding.',
                    textAlign: TextAlign.center,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:client_pannel/features/app/presentations/widget/home_widget/home_nearby_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../../core/themes/app_colors.dart';

class NearbyShowMapWidget extends StatelessWidget {
  const NearbyShowMapWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.mapController,
  });

  final double screenHeight;
  final double screenWidth;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppPalette.hintColor,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: HomeScreenNearbyWIdget(mapController: mapController),
      ),
    );
  }
}

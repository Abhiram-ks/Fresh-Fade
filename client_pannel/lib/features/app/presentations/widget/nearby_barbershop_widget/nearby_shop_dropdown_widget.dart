import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/distance_filter_cubit/distance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../state/cubit/distance_filter_cubit/distance_state.dart' show DistanceFilter, DistanceFilterExtension;

Container nearbyShopDrpdownWIdget( BuildContext context, double screenHeight, double screenWidth) {
  return Container(
    height: screenHeight * 0.07,
    width: screenWidth,
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
    alignment: Alignment.center,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.008,
      ),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppPalette.hintColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppPalette.orengeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: AppPalette.orengeColor,
              size: 18,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            'Distance',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppPalette.whiteColor.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: BlocBuilder<DistanceFilterCubit, DistanceFilter>(
              builder: (context, selectedDistance) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<DistanceFilter>(
                    value: selectedDistance,
                    isExpanded: true,
                    dropdownColor: AppPalette.blackColor.withValues(alpha: 0.8),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppPalette.orengeColor,
                      size: 20,
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.orengeColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    items: DistanceFilter.values.map((distance) {
                      return DropdownMenuItem<DistanceFilter>(
                        value: distance,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.near_me_rounded,
                                size: 16,
                                color: AppPalette.orengeColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                distance.label,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.read<DistanceFilterCubit>().selectDistance(newValue);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


import 'package:client_pannel/core/common/custom_button.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_admin_service_bloc/fetch_admin_service_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/select_gender_cubit/select_gender_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/search_widget/search_service_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/cubit/select_rating_cubit/select_rating_cubit.dart';
import '../../state/cubit/select_service_cubit/select_service_cubit.dart';

Expanded serchFilterActionItems(
  double screenWidth,
  BuildContext context,
  double screenHeight,
) {
  return Expanded(
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  
                  showCupertinoModalPopup(
                    context: context,
                    builder:(modalContext) => CupertinoActionSheet(
                          title: Text('Session Exception Warning!'),
                          message: Text(
                            'Are you sure you want to clear the following filters? Tap "Allow" to continue.',
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () {
                                context.read<SelectServiceCubit>().clearAll();
                                context
                                    .read<GenderOptionCubit>()
                                    .selectGenderOption(null);
                                context.read<RatingCubit>().clearRating();
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              isDefaultAction: true,
                              child: const Text("Allow", style: TextStyle(color: AppPalette.orengeColor,fontSize: 16),),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              isDestructiveAction: true,
                              child: const Text("Don't Allow", style: TextStyle(color: AppPalette.blackColor,fontSize: 16),),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            isDestructiveAction: true,
                            child: const Text("Cancel", style: TextStyle(color: AppPalette.blackColor,fontSize: 16),),
                          ),
                        ),
                  );
                },
                child: Text(
                  'Clear Filters',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ConstantWidgets.hight10(context),
            BlocBuilder<FetchAdminServiceBloc, FetchAdminServiceState>(
              builder: (context, state) {
                if (state is FetchAdminServiceSuccess) {  
                  final services = state.services;
                  return BlocBuilder<SelectServiceCubit, Set<String>>(
                    builder: (context, selectedServices) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: List.generate(services.length, (index) {
                            final serviceName = services[index].name;
                            final isSelected = selectedServices.contains(
                              serviceName,
                            );

                            return serviceTags(
                              onTap: () {
                                context
                                    .read<SelectServiceCubit>()
                                    .toggleService(serviceName);
                              },
                              text: serviceName,
                              isSelected: isSelected,
                            );
                          }),
                        ),
                      );
                    },
                  );
                } 
                 else if (state is FetchAdminServiceEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('No services available', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        Text('No data to process', style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                        ConstantWidgets.hight20(context),
                      ],
                    )
                  );
                } 
                else if (state is FetchAdminServiceError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Unable to load services', style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        Text(state.error, style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                        ConstantWidgets.hight20(context),
                      ],
                    )
                  );
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyColor,    
                  highlightColor: AppPalette.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(10, (index) {
                        final serviceName = 'Loading..';
                        final isSelected = false;

                        return serviceTags(
                          onTap: () {},
                          text: serviceName,
                          isSelected: isSelected,
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: BlocBuilder<RatingCubit, double>(
                builder: (context, rating) {
                  return Center(
                    child: RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      glow: true,
                      unratedColor: AppPalette.hintColor,
                      glowColor: AppPalette.greyColor,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                              Icon(Icons.star, color: AppPalette.buttonColor),
                      onRatingUpdate: (value) {
                        context.read<RatingCubit>().setRating(value);
                      },
                    ),
                  );
                },
              ),
            ),
            ConstantWidgets.hight10(context),
            BlocBuilder<GenderOptionCubit, GenderOption?>(
              builder: (context, selectedGender) {
                return Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 2,
                  children:
                      GenderOption.values.map((gender) {
                        Color activeColor;
                        String label;

                        switch (gender) {
                          case GenderOption.male:
                            activeColor =AppPalette.orengeColor;
                            label = "Male";
                            break;
                          case GenderOption.female:
                            activeColor = AppPalette.orengeColor;
                            label = "Female";
                            break;
                          case GenderOption.unisex:
                            activeColor =AppPalette.orengeColor;
                            label = "Unisex";
                            break;
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<GenderOption>(
                              value: gender,
                              // ignore: deprecated_member_use
                              groupValue: selectedGender,
                              activeColor: activeColor,
                              // ignore: deprecated_member_use
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<GenderOptionCubit>()
                                      .selectGenderOption(value);
                                }
                              },
                            ),
                            Text(label),
                          ],
                        );
                      }).toList(),
                );
              },
            ),
            ConstantWidgets.hight20(context),
            CustomButton(text: 'Apply Filters', onPressed: (){
                final selectedServices =context.read<SelectServiceCubit>().state;
                final rating = context.read<RatingCubit>().state;
                final gender = context.read<GenderOptionCubit>().state;

                if (selectedServices.isEmpty &&
                    rating == 0.0 &&
                    gender == null) {
                  context.read<FetchAllbarberBloc>().add(
                    FetchAllBarbersRequested(),
                  );
                } else {
                  context.read<FetchAllbarberBloc>().add(
                    FilterBarbersRequested(
                      selectServices: selectedServices,
                      rating: rating,
                      gender: gender?.name == 'unisex' ? null : gender?.name,
                    ),
                  );
                }
            }),
          ],
        ),
      ),
    ),
  );
}

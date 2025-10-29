import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/cubit/tab_cubit/tab_cubit.dart';
import 'detail_barber_review_widget.dart';
import 'detail_imagescroll_widget.dart';
import 'detail_post_widget.dart';
import 'detail_service_widget.dart';
import 'detail_top_portion_widget.dart';

Shimmer detailshowWidgetLoading(BarberEntity barber, double screenHeight, double screenWidth, BuildContext context) {
    return Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                  highlightColor: AppPalette.whiteColor,
                  child: Column(
                    children: [
                      ImageScolingWidget(
                          imageList: [
                            barber.image ?? AppImages.barberEmpty,
                            barber.detailImage ?? AppImages.barberEmpty
                          ],
                          show: true,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                      DetailTopPortionWidget(
                          screenWidth: screenWidth, barber: barber),
                      ConstantWidgets.hight30(context),
                      BlocProvider(
                        create: (context) => TabCubit(),
                        child: Expanded(
                          child: Column(
                            children: [
                              BlocBuilder<TabCubit, int>(
                                builder: (context, selectedIndex) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(3, (index) {
                                      final tabs = [
                                        'Post',
                                        'Services',
                                        'review'
                                      ];
                                      return GestureDetector(
                                        onTap: () => context
                                            .read<TabCubit>()
                                            .changeTab(index),
                                        child: Column(
                                          children: [
                                            Text(
                                              tabs[index],
                                              style: TextStyle(
                                                fontWeight:
                                                    selectedIndex == index
                                                        ? FontWeight.w900
                                                        : FontWeight.bold,
                                                color: selectedIndex == index
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                            ),
                                            ConstantWidgets.hight20(context)
                                          ],
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                              Expanded(
                                child: BlocBuilder<TabCubit, int>(
                                  builder: (context, selectedIndex) {
                                    return IndexedStack(
                                      index: selectedIndex,
                                      children: [
                                        DetailPostWidget(),
                                        DetilServiceWidget(
                                          screenWidth: screenWidth,
                                        ),
                                        DetailsReviewWidget(
                                          barber: barber,
                                          screenHight: screenHeight,
                                          screenWidth: screenWidth,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
  }
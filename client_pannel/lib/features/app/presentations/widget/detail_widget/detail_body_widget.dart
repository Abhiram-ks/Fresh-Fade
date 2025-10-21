import 'package:client_pannel/core/themes/app_colors.dart';
import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:client_pannel/features/app/presentations/widget/detail_widget/detail_barber_review_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/detail_widget/detail_post_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/detail_widget/detail_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_post_bloc/fetch_barber_post_bloc.dart';
import '../../state/cubit/tab_cubit/tab_cubit.dart';
import 'detail_imagescroll_widget.dart';
import 'detail_top_portion_widget.dart';
import 'detail_widget_loading.dart';

class DetailScreenWidgetBuilder extends StatefulWidget {
  const DetailScreenWidgetBuilder({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberId,
  });

  final double screenHeight;
  final String barberId;
  final double screenWidth;

  @override
  State<DetailScreenWidgetBuilder> createState() => _DetailScreenWidgetBuilderState();
}

class _DetailScreenWidgetBuilderState extends State<DetailScreenWidgetBuilder> {
    @override
  void initState() {
    super.initState();
    context
        .read<FetchAbarberBloc>()
        .add(FetchABarberEventRequest(barberId: widget.barberId));
    context
        .read<FetchBarberServiceBloc>()
        .add(FetchBarberServiceRequest(barberId: widget.barberId));
    context
        .read<FetchBarberPostBloc>()
        .add(FetchBarberPostRequest(barberId: widget.barberId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAbarberBloc, FetchAbarberState>(
      builder: (context, state) {
        if (state is FetchAbarberLoading) {
          BarberEntity barber = BarberEntity(
              uid:'',
              barberName:'barberNamei',
              ventureName:'Cavlog - Executing smarter, Manaing better',
              phoneNumber: 'phoneNumber',
              address:'221B Baker street Santa clau 101 saint NIcholas Dive North Pole, Landon -  99705',
              email: 'cavlogenoia@gmail.com',
              isVerified: true,
              isBloc: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              rating: 0,
              image: '',
              detailImage: '',
              gender: '',
              age: 0,
            );
          return detailshowWidgetLoading(
              barber, widget.screenHeight, widget.screenWidth, context);
        } else if (state is FetchABarberSuccess) {
          final barber = state.barber;
          return Column(
            children: [
              ImageScolingWidget(
                  imageList: [
                    barber.image ?? AppImages.barberEmpty,
                    barber.detailImage ?? AppImages.barberEmpty
                  ],
                  show: true,
                  screenHeight: widget.screenHeight,
                  screenWidth: widget.screenWidth),
              DetailTopPortionWidget(screenWidth: widget.screenWidth, barber: barber),
              ConstantWidgets.hight30(context),
              BlocProvider(
                create: (context) => TabCubit(),
                child: Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<TabCubit, int>(
                        builder: (context, selectedIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              final tabs = ['Post', 'Services', 'review'];
                              return GestureDetector(
                                onTap: () =>
                                    context.read<TabCubit>().changeTab(index),
                                child: Column(
                                  children: [
                                    Text(
                                      tabs[index],
                                      style: TextStyle(
                                        fontWeight: selectedIndex == index
                                            ? FontWeight.w900
                                            : FontWeight.bold,
                                        color: selectedIndex == index
                                            ? AppPalette.blackColor
                                            : AppPalette.greyColor,
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
                                DetilServiceWidget(screenWidth: widget.screenWidth),
                                DetailsReviewWidget(
                                    barber: barber,
                                    screenHight: widget.screenHeight,
                                    screenWidth: widget.screenWidth)
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
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                color: AppPalette.blackColor,
                size: 50,
              ),
              Text("Oop's Unable to complete the request."),
              Text('Please try again later.'),
              IconButton(
                  onPressed: () {
                    context
                        .read<FetchAbarberBloc>()
                        .add(FetchABarberEventRequest(barberId: widget.barberId));
                  },
                  icon: Icon(Icons.refresh_rounded))
            ],
          ),
        );
      },
    );
  }
}

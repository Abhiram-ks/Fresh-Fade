
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/service_selection_cubit/service_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../widgets/clip_chip_maker_widget.dart';

class BookingServiceBuilder extends StatelessWidget {
  const BookingServiceBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>(
      builder: (context, state) {
        if (state is FetchBarberServiceLoading) {
           return SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => ConstantWidgets.width40(context),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300] ?? AppPalette.greyColor,
                highlightColor: AppPalette.whiteColor,
                child: ClipChipMaker.build(
                  text: 'HairCut ₹150',
                  actionColor: AppPalette.hintColor,
                  textColor: AppPalette.blackColor,
                  backgroundColor: AppPalette.whiteColor,
                  borderColor: AppPalette.greyColor,
                  onTap: () {},
                ),
              );
            },
          ),
        );
        }
        if (state is FetchBarberServiceEmpty) {
         return Center(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Icon(Icons.face_retouching_natural),
                  ConstantWidgets.width40(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                     Text("Oops! There's nothing here yet."),
                    Text('Still waiting for that first style.'),
                  ],
                ),
              ],
            ),
          );
        } 
        else if (state is FetchBarberServiceSuccess) {
          final services = state.services;
          return BlocBuilder<ServiceSelectionCubit, ServiceSelectionState>(
            builder: (context, serviceState) {
              return SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      ConstantWidgets.width40(context),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = context
                        .watch<ServiceSelectionCubit>()
                        .isSelected(service.serviceName);
                    return ClipChipMaker.build(
                      text:"${service.serviceName}   ₹ ${service.amount}",
                      actionColor: isSelected
                          ? const Color.fromARGB(255, 227, 229, 234)
                          : Color.fromARGB(255, 248, 239, 216),
                      textColor: AppPalette.blackColor,
                      backgroundColor: isSelected
                          ? Color.fromARGB(255, 248, 239, 216)
                          : AppPalette.whiteColor,
                      borderColor: isSelected
                          ? Color(0xFFFEBA43)
                          : AppPalette.hintColor,
                      onTap: () {
                        context.read<ServiceSelectionCubit>().toggleSeletion(service.serviceName,service.amount.toDouble());
                      },
                    );
                  },
                ),
              );
            },
          );
        }
        return Center(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Icon(Icons.face_retouching_natural,color: AppPalette.redColor,),
                  ConstantWidgets.width40(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Oop's Unable to complete the request."),
                     Text('Please try again later.'),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }
}
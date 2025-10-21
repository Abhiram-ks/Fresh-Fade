import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';

class DetilServiceWidget extends StatelessWidget {
  final double screenWidth;
  const DetilServiceWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>
    (builder: (context, state) {
      if (state is FetchBarberServiceLoading) {
        return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight30(context),
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: AppPalette.orengeColor,
                          backgroundColor: AppPalette.hintColor,
                          strokeWidth: 2,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      Text('Just a moment...'),
                      Text('Please wait while we process your request'),
                    ],
                  ),
                );
       } 
      else if (state is FetchBarberServiceSuccess) {
       final services = state.services;

       return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenWidth * .08),
          child: Column(
            children: [
              ListView.separated(
                itemCount: services.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( service.serviceName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) ),
                          Row(
                            children: [
                               Text( "₹ ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppPalette.orengeColor)),
                               Text( "${service.amount} ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          )
                    ],
                  );
                }, 
                separatorBuilder: (context, index) => ConstantWidgets.hight10(context), 
                ),
                ConstantWidgets.hight50(context),
                ConstantWidgets.hight50(context),
            ],
            
          ),
          ),
       );
      }
      else if (state is FetchBarberServiceEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_natural, size: 50,),
              ConstantWidgets.hight20(context),
              Text('Still waiting for that first style.'),
            ],
          ),
        );
      }
                   return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidgets.hight30(context),
                    Icon(
                      Icons.cloud_off_outlined,
                      color: AppPalette.blackColor,
                      size: 50,
                    ),
                    Text("Oop's Unable to complete the request."),
                    Text('Please try again later.'),
                  ],
                ),
              );
    },);
  }
}
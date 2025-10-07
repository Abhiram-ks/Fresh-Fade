
import 'package:admin_pannel/features/presentation/state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'package:admin_pannel/features/presentation/widgets/service_widget/service_state_handle.dart';
import 'package:admin_pannel/features/presentation/widgets/service_widget/service_tag_widget.dart';
import 'package:admin_pannel/features/presentation/widgets/service_widget/service_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_service_bloc/fetch_service_bloc.dart';

class ServiceBuilderWidget extends StatelessWidget {
  const ServiceBuilderWidget({super.key, required this.widget});

  final UploadServicesWidget widget;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceMangementBloc, ServiceMangementState>(
      listener: (context, state) {
        handSeviceState(context, state);
      },
      child: BlocBuilder<FetchingServiceBloc, FetchServiceState>(
        builder: (context, state) {
          if (state is ServiceLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstantWidgets.hight50(context),
                  SizedBox(
                    width: 15, // adjust to 16, 20, 30 etc.
                    height: 15,
                    child: CircularProgressIndicator(
                      color: AppPalette.blueColor,
                      backgroundColor: AppPalette.hintColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                  ConstantWidgets.hight10(context),
                  Text('Just a moment...'),
                  Text(
                    'Please wait while we process your request',
                    style: GoogleFonts.inter(fontSize: 11),
                  ),
                ],
              ),
            );
          } else if (state is ServiceEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstantWidgets.hight50(context),
                  Text(
                    "Oops! There's nothing here yet.",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          } else if (state is ServiceLoadedState) {
            return Wrap(
              spacing: 4,
              runSpacing: 5,
              children:
                  state.services.map((service) {
                    return ServiceTagsWidget(
                      text: service.name,
                      edit: () {
                        context.read<ServiceMangementBloc>().add(
                          EditServiceEvent(
                            serviceId: service.id,
                            serviceName: service.name,
                          ),
                        );
                      },
                      delete: () {
                        context.read<ServiceMangementBloc>().add(
                          DeleteServiceEvent(service.id),
                        );
                      },
                    );
                  }).toList(),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstantWidgets.hight50(context),
                Icon(
                  Icons.cloud_off_outlined,
                  color: AppPalette.blackColor,
                  size: 50,
                ),
                Text(
                  "Oop's Unable to complete the request. Please try again later.",
                  style: GoogleFonts.inter(fontSize: 11),
                  textAlign: TextAlign.center,
                ),

                IconButton(
                  onPressed: () {
                    context.read<FetchingServiceBloc>().add(
                      FetchServiceDataEvent(),
                    );
                  },
                  icon: Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
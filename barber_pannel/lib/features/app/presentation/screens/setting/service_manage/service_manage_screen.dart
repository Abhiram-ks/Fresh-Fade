

import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_service_modification_bloc/barber_service_modification_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/service_edit_cubit/service_edit_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/common/custom_testfiled.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../../core/validation/validation_helper.dart';

class ServiceManageScreen extends StatelessWidget {
  const ServiceManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchBarberServiceBloc>()),
        BlocProvider(create: (context) => EditModeCubit()),
        BlocProvider(create: (context) => sl<BarberServiceModificationBloc>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: CustomAppBar2(
                  isTitle: true,
                  title: 'Service Management',
                  iconColor: AppPalette.blackColor,
                  actions: [
                    IconButton(onPressed: () {
                      context.read<EditModeCubit>().toggleEditMode();
                    }, icon: const Icon(Icons.edit)),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.serviceAdd);
                      },
                      icon: const Icon(Icons.add),
                    ),
                    ConstantWidgets.width20(context),
                  ],
                ),
                body: BarberServiceBuilderWIdget(screenWidth: screenWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BarberServiceBuilderWIdget extends StatefulWidget {
  const BarberServiceBuilderWIdget({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  State<BarberServiceBuilderWIdget> createState() => _BarberServiceBuilderWIdgetState();
}

class _BarberServiceBuilderWIdgetState extends State<BarberServiceBuilderWIdget> {
  @override
  void initState() {
    super.initState();
    context.read<FetchBarberServiceBloc>().add(FetchBarberServiceRequest());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberServiceBloc, FetchBarberServiceState>(
      builder: (context, state) {
        if (state is FetchBarberServiceEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('No Services Added!', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('Wail progressing with empty data', style: TextStyle(fontSize: 13),),
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.serviceAdd);
                }, icon: Icon(Icons.add))
              ],
            ),
          );
        } else if (state is FetchBarberServiceLoading) {
          return Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                color: AppPalette.hintColor,
                backgroundColor: AppPalette.buttonColor,
                strokeWidth: 2,
              ),
            )
          );
        }
        if (state is FetchBarberServiceLoaded) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Management',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ConstantWidgets.hight10(context),
                      const Text(
                        'Craft your perfect service lineup — add, update, or fine-tune offerings to match your brand’s style.',
                      ),
                      ConstantWidgets.hight30(context),
                    ],
                  ),
                ),
                BlocListener<BarberServiceModificationBloc, BarberServiceModificationState>(
                  listener: (context, state) {
                    handleServiceEditAndUpdaTeState(context, state);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.08),
                    child: Column(
                      children: [
                        Column(
                          children: state.services.map((service) {
                            return ServiceManagementFiled(
                              context: context,
                              screenWidth: widget.screenWidth,
                              icon: Icons.currency_rupee_sharp,
                              label: service.serviceName,
                              serviceRate: service.serviceRate.toStringAsFixed(0),
                              deleteAction: () {
                                context.read<BarberServiceModificationBloc>().add(
                                    DeleteServiceEventRequest(
                                        barberID: service.id,
                                        serviceKey: service.serviceName));
                              },
                              updateAction: (value) {
                                context.read<BarberServiceModificationBloc>().add(
                                      FetchBarberServiceUpdateRequestEvent(
                                        barberID: service.id,
                                        serviceKey: service.serviceName,
                                        oldServiceRate: service.serviceRate,
                                        serviceRate: value,
                                      ),
                                    );
                              },
                            );
                          }).toList(),

                        ),
                            ConstantWidgets.hight50(context),
                      ],

                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Unable to complete the request.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
              Text('Please try again later.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13),),
              IconButton(onPressed: (){
                context.read<FetchBarberServiceBloc>().add(FetchBarberServiceRequest());
              }, icon: const Icon(Icons.refresh))
            ],
          ),
        );
      },
    );
  }
}



class ServiceManagementFiled extends StatefulWidget {
    ServiceManagementFiled({
      super.key,
      required this.context,
      required this.screenWidth,
      required this.label,
      required this.icon,
      required this.serviceRate,
      required this.deleteAction,
      required this.updateAction,
      this.firstIconColor,
      this.firstIconBgColor,
      this.secoundIconColor,
      this.secoundIconBgColor,
      this.updateDeletIcon,
      this.updateOntap,
      this.updateIcon});

  final BuildContext context;
  final double screenWidth;
  final String label;
  final String serviceRate;
  final VoidCallback deleteAction;
  final IconData icon;
  VoidCallback? updateOntap;
  IconData? updateIcon;
  Color? firstIconColor;
  Color? firstIconBgColor;
  Color? secoundIconColor;
  Color? secoundIconBgColor;
  IconData? updateDeletIcon;
  final void Function(double value) updateAction; 

  @override
  State<ServiceManagementFiled> createState() => _ServiceManagementFiledState();
}

class _ServiceManagementFiledState extends State<ServiceManagementFiled> {
  late final TextEditingController serviceRateController;

  @override
  void initState() {
    super.initState();
    serviceRateController = TextEditingController(text: widget.serviceRate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<EditModeCubit, bool>(
            builder: (context, isEditable) {
              return TextFormFieldWidget(
                enabled: isEditable,
                label: widget.label,
                hintText: 'Enter your charge',
                prefixIcon: widget.icon,
                controller: serviceRateController,
                validate: ValidatorHelper.validateAmount,
              );
            },
          ),
        ),
        ConstantWidgets.width10(context),
        Container(
          height:50,
          width:50,
          decoration: BoxDecoration(
            color: widget.firstIconBgColor ?? AppPalette.whiteColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            splashColor: Colors.white,
            highlightColor: AppPalette.hintColor.withAlpha(128),
            focusColor: AppPalette.greenColor,
            onPressed:(){
               final value = double.tryParse(serviceRateController.text.trim());
               if(value != null){
                widget.updateAction(value);
               }
                 if (widget.updateOntap != null) {
                   widget.updateOntap!(); 
                }
            },
            icon: Icon(
              widget.updateIcon ?? CupertinoIcons.floppy_disk,
              color: widget.firstIconColor ?? AppPalette.buttonColor,
            ),
          ),
        ),
        ConstantWidgets.width10(context),
        Container(
          height:50,
          width:50,
          decoration: BoxDecoration(
            color:widget.secoundIconBgColor ?? AppPalette.whiteColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            splashColor: Colors.white,
            highlightColor:AppPalette.hintColor.withAlpha(128),
            focusColor: AppPalette.greenColor,
            onPressed: widget.deleteAction,
            icon: Icon(
               widget.updateDeletIcon ?? CupertinoIcons.delete_solid,
              color:widget.secoundIconColor ?? AppPalette.redColor,
            ),
          ),
        ),
      ],
    );
  }
}




void handleServiceEditAndUpdaTeState(BuildContext context, BarberServiceModificationState state) {
  if (state is BarberServiceModificationDeleteAlert) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Session Confirmation!',
      message: 'Delete "${state.serviceName}" permanently? This action can’t be undone. Tap "Allow" to confirm.',
      firstButtonText: 'Allow',
      secondButtonText: 'Don’t Allow',
      firstButtonColor: AppPalette.redColor,
      onTap: () {
        context.read<BarberServiceModificationBloc>().add(DeleteServiceEventConfirm());
      },
    );
  } else if (state is BarberServiceModificationUpdateAlert){
     CustomCupertinoDialog.show(
      context: context,
      title: 'Session Overriting!',
      message: 'Update ${state.serviceName} Rate from "₹${state.oldServiceRate}" to "₹${state.serviceRate}"',
      firstButtonText: 'Allow',
      secondButtonText: 'May be Later',
      firstButtonColor: AppPalette.buttonColor,
      onTap: () {
        context.read<BarberServiceModificationBloc>().add(FetchBarberServiceUpdateConfirmEvent());
      },
    );
  } else if(state is BarberServiceModificationLoading){
    CustomSnackBar.show(context, message: 'Updating...', textAlign: TextAlign.center);
  } else if(state is BarberServiceModificationLoaded){
    CustomSnackBar.show(context, message: '${state.message} Successfully!', textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);
  } else if (state is BarberServiceModificationError) {
     CustomSnackBar.show(context, message: state.message, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
} 

}

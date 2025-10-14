import 'package:barber_pannel/core/common/custom_appbar.dart';
import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/common/custom_button.dart';
import 'package:barber_pannel/core/common/custom_dialogbox.dart';
import 'package:barber_pannel/core/common/custom_snackbar.dart';
import 'package:barber_pannel/core/di/injection_contains.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_/barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/service_select_cubit/service_select_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/common/custom_testfiled.dart';
import '../../../../../../core/constant/constant.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../../../../core/validation/validation_helper.dart';
import '../../../state/bloc/fetch_bloc/fetch_service_bloc/fetch_service_bloc.dart';

class ServiceAddScreen extends StatefulWidget {
  const ServiceAddScreen({super.key});

  @override
  State<ServiceAddScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {
  final TextEditingController serviceRateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ServiceSelectCubit()),
        BlocProvider(create: (context) => sl<FetchServiceBloc>()),
        BlocProvider(create: (context) => sl<BarberServiceBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: CustomAppBar2(
                  title: 'Service Deployment',
                  isTitle: true,
                ),
                body: ServiceAddBodyWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  formKey: _formKey,
                  serviceRateController: serviceRateController,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: BlocBuilder<FetchServiceBloc, FetchServiceState>(
                  builder: (context, state) {
                    if (state is FetchServiceLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 50,
                          child: BlocBuilder<ServiceSelectCubit, ServiceSelectState>(
                            builder: (context, serviceState) {
                              return BlocListener<BarberServiceBloc, BarberServiceState>(
                                listener: (context, state) {
                                  handleBarberServiceState(context, state);
                                },
                                child: CustomButton(
                                  text: "Upload",
                                  onPressed: () {
                                    final selectedService = context
                                        .read<ServiceSelectCubit>()
                                        .state
                                        .selectedServiceName;
                                    
                                    if (_formKey.currentState!.validate()) {
                                      if (selectedService.isNotEmpty) {
                                        String input = serviceRateController.text.trim();
                                        double value = double.tryParse(input) ?? 0.0;
                                        context.read<BarberServiceBloc>().add(
                                              AddBarberServiceEvent(
                                                serviceName: selectedService,
                                                serviceRate: value,
                                              ),
                                            );
                                      } else {
                                        CustomSnackBar.show(context, message: "Please select a service!", textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
                                      }
                                    } else {
                                      CustomSnackBar.show(
                                        context,
                                        message: 'Complete Required Fields!',
                                        textAlign: TextAlign.center,
                                        backgroundColor: AppPalette.redColor,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              )
            
            ),
          );
        },
      ),
    );
  }
}


class ServiceAddBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final GlobalKey<FormState> formKey;
  final TextEditingController serviceRateController;

  const ServiceAddBodyWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.formKey,
    required this.serviceRateController,
  });

  @override
  State<ServiceAddBodyWidget> createState() => _ServiceAddBodyWidgetState();
}

class _ServiceAddBodyWidgetState extends State<ServiceAddBodyWidget> {
  @override
  void initState() {
    super.initState();
    context.read<FetchServiceBloc>().add(FetchServiceRequest());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchServiceBloc, FetchServiceState>(
                  builder: (context, state) {
                    if (state is FetchServiceLoading) {
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
                    else if (state is FetchServiceLoaded) {
                      final services = state.service;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.screenWidth * 0.08,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Form(
                            key: widget.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Deployment',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ConstantWidgets.hight10(context),
                                Text(
                                  'Set up and showcase your perfect service lineup. Craft a professional presentation and deploy it with ease.',
                                ),
                                ConstantWidgets.hight20(context),
                                BlocBuilder<ServiceSelectCubit, ServiceSelectState>(
                                  builder: (context, state) {
                                    return TextFormFieldWidget(
                                      label: state.selectedServiceName,
                                      hintText: "Enter your charge",
                                      prefixIcon: Icons.currency_rupee,
                                      controller: widget.serviceRateController,
                                      validate: ValidatorHelper.validateAmount,
                                      enabled: state.isEnabled,
                                    );
                                  },
                                ),
                                ConstantWidgets.hight20(context),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(services.length, (
                                      index,
                                    ) {
                                      final serviceName =
                                          services[index].name;
                                      final isSelected =
                                          context
                                              .watch<ServiceSelectCubit>()
                                              .state
                                              .selectedServiceName ==
                                          serviceName;
                                      return serviceTags(
                                        onTap: () {
                                          context
                                              .read<ServiceSelectCubit>()
                                              .selectService(serviceName);
                                        },
                                        text: serviceName,
                                        isSelected: isSelected,
                                      );
                                    }),
                                  ),
                                ),
                                ConstantWidgets.hight50(context),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Unable to complete the request.",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                          Text('Please try again later.',style: TextStyle(fontSize: 12,),textAlign: TextAlign.center,),
                          IconButton(onPressed: (){
                            context.read<FetchServiceBloc>().add(FetchServiceRequest());
                          }, icon: Icon(Icons.refresh))
                        ],
                      ),
                    );
                  },
                );
  }
}

InkWell serviceTags(
    {required VoidCallback onTap,
    required String text,
    required bool isSelected}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: isSelected ? AppPalette.buttonColor : AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppPalette.buttonColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 18,
              color: isSelected ? AppPalette.whiteColor : AppPalette.buttonColor)),
    ),
  );
}



void handleBarberServiceState(BuildContext context, BarberServiceState state) {
  final buttonCubit = context.read<ProgresserCubit>();
  if (state is BarberServiceConfirmationAlertState) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Session Confirmation!',
      message: 'Are you sure you want to proceed with this service? Service Name: ${state.text} & Charge: ₹${state.amount.toStringAsFixed(2)} Tap Allow to continue.',
      firstButtonText: 'Allow',
      secondButtonText: "Maybe Later",
      firstButtonColor: AppPalette.buttonColor,
      onTap: () {
        context  .read<BarberServiceBloc>().add(BarberServiceConfirmationEvent());
      },
    );
  } else if (state is BarberServiceLoading) {
    buttonCubit.startLoading();
  } else if (state is BarberServiceSuccess) {
    Navigator.pop(context);
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: 'Service Uploaded Success!', textAlign: TextAlign.center, backgroundColor: AppPalette.greenColor);
  } else if (state is BarberServiceFailure) {
    buttonCubit.stopLoading();
    CustomSnackBar.show(context, message: state.message, textAlign: TextAlign.center, backgroundColor: AppPalette.redColor);
  }
}

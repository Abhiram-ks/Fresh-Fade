import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/core/constant/constant.dart';
import 'package:barber_pannel/core/themes/app_colors.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_dates_bloc/fetch_slot_dates_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_slot_specific_data_bloc/fetch_slot_specific_data_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/modify_slots_generate_bloc/modify_slots_generate_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/calender_picker_cubit/calender_picker_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/duration_picker/duration_picker_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/page_swich_cubit/page_switch_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/service_edit_cubit/service_edit_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/time_picker_cubit/time_picker_cubit.dart' show TimePickerCubit;
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/time_manage_duration_picker.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/time_widget/time_management_pagetwo.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/data/datasource/auth_local_datasouce.dart';
import '../../../../data/datasource/slot_remote_datasource.dart';
import '../../../../data/repo/update_slot_repo_impl.dart';
import '../../../state/bloc/generate_slots_bloc/generate_slot_bloc.dart';
import '../../../widget/settings_widget/time_widget/time_management_date_picker.dart';
import '../../../widget/settings_widget/time_widget/time_managemnt_date_picker.dart';
import '../../../widget/settings_widget/time_widget/time_slotgenerate_actionbutton.dart';

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  State<TimeManagementScreen> createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _deleteOldSlots();
  // }

  // Future<void> _deleteOldSlots() async {
  //   await context.read<SlotDeletePriviousCubit>().deleteOldSlots();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalenderPickerCubit()),
        BlocProvider(create: (_) => TimePickerCubit()),
        BlocProvider(create: (_) => EditModeCubit()),
        BlocProvider(create: (_) => DurationPickerCubit()),
        BlocProvider(create: (_) => ServicePageCubit()),
        BlocProvider(create: (_) => GenerateSlotBloc(SlotRepositoryImpl(), AuthLocalDatasource())),
        BlocProvider(create: (_) => FetchSlotsDatesBloc(fetchSlotsRepository: FetchSlotsRepositoryImpl(), localDB: AuthLocalDatasource())),
        BlocProvider(create: (_) => FetchSlotsSpecificdateBloc(FetchSlotsRepositoryImpl(), AuthLocalDatasource())),
        BlocProvider(create: (_) => ModifySlotsGenerateBloc(SlotUpdateRepositoryImpl())),
        BlocProvider(create: (_) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return SafeArea(
            child: Scaffold(
                appBar: CustomAppBar2(
                  title: 'Time Management',
                  isTitle: true,
                  actions: [
                    BlocBuilder<ServicePageCubit, CurrentServicePage>(
                      builder: (context, state) {
                        final isPageOne = state == CurrentServicePage.pageOne;
                        return IconButton(onPressed: () {
                          isPageOne
                              ? context.read<ServicePageCubit>().goToPageTwo()
                              : context.read<ServicePageCubit>().goToPageOne();     
                        }, icon: Icon(isPageOne ? Icons.scale_outlined: Icons.schedule_outlined),color:  AppPalette.buttonColor
                        );
                      },
                    ),
                    ConstantWidgets.width20(context)
                  ],
                ),
                body: 
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: BlocBuilder<ServicePageCubit, CurrentServicePage>(
                    builder: (context, state) {
                      switch (state) {
                       /*--------------------------------------------
                        Call for the generated slots session part & 
                        manage the display of generated slots through 
                        appropriate widgets and handlers.
                      ---------------------------------------------*/
          
                        case CurrentServicePage.pageOne:
                          return TimeManagementPageOne(screenWidth: screenWidth,screenHeight: screenHeight);
                        case CurrentServicePage.pageTwo:
                          return TimeManagementPageTwo(screenWidth: screenWidth,screenHeight: screenHeight);
                      }
                    },
                  ),
                ),
                ),
          );
        },
      ),
    );
  }
}






class TimeManagementPageOne extends StatelessWidget {
  const TimeManagementPageOne({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchSlotsDatesBloc>().add(FetchSlotsDateRequest());
    });

    

    return Column(
      children: [
        TimeManagementDatePIcker(),
        ConstantWidgets.hight20(context),
       timeManagementDatePIckerFunction,
        timeManagementDurationPIckerFunction,
        ConstantWidgets.hight20(context),
        generateSlotsActionbutton(context,screenWidth, screenHeight)
      ],
    );
  }
}



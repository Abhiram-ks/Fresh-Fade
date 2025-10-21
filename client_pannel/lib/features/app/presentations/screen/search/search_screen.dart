import 'package:client_pannel/core/common/custom_cupertino_dialog.dart';
import 'package:client_pannel/core/common/custom_snackbar.dart';
import 'package:client_pannel/core/common/custom_testfiled.dart';
import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/presentations/state/bloc/fetch_bloc/fetch_admin_service_bloc/fetch_admin_service_bloc.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/select_gender_cubit/select_gender_cubit.dart';
import 'package:client_pannel/features/app/presentations/state/cubit/select_service_cubit/select_service_cubit.dart';
import 'package:client_pannel/features/app/presentations/widget/search_widget/barber_list_builder.dart';
import 'package:client_pannel/features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:client_pannel/service/voice/voice_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../../core/debouncer/debouncer.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/validation/validator_helper.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart';
import '../../state/cubit/select_rating_cubit/select_rating_cubit.dart';
import '../../state/cubit/voice_cubit/voice_cubit.dart';
import '../../widget/search_widget/search_appbar.dart';



class GlobalSearchController {
  static final TextEditingController searchController = TextEditingController();
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
  with AutomaticKeepAliveClientMixin {
  final Debouncer debouncer = Debouncer(milliseconds: 100);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late VoiceService _voiceSearchUseCase;
  late VoiceSearchCubit _voiceSearchCubit;
  
  @override
  void initState() {
    super.initState();
    _voiceSearchUseCase = VoiceService(stt.SpeechToText());
    _voiceSearchCubit = sl<VoiceSearchCubit>();
    GlobalSearchController.searchController.addListener(_handleControllerChange);
  }

    @override
  bool get wantKeepAlive => true;



  void _handleControllerChange() {
    if (mounted && _voiceSearchCubit.state.isListening) {
      _onSearchChanged(GlobalSearchController.searchController.text);
    }
  }

  void _startVoiceSearch() => _voiceSearchCubit.startVoiceSearch(_voiceSearchUseCase);

  void _stopVoiceSearch() =>  _voiceSearchCubit.stopVoiceSearch();

  Future<void> _handleRefresh() async {
    context.read<FetchAllbarberBloc>().add(FetchAllBarbersRequested());
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    CustomCupertinoDialog.show(
      context: context,
      title: 'Microphone Permission Required',
      message: 'Voice search requires microphone permission to work. To enable it.\n'
      '1. Go to your device Settings\n'
      '2. Open Apps → FreshFade\n'
      '3. Tap Permissions\n'
      '4. Enable Microphone permission',
      onTap: () {
        Permission.microphone.request().then((status) {
          if (status.isGranted) {
            _voiceSearchCubit.startVoiceSearch(_voiceSearchUseCase);
          }
        });
      },
      firstButtonText: 'Grant Permission',
      secondButtonText: 'Cancel',
      firstButtonColor: AppPalette.buttonColor,
    );
  }

  void _onSearchChanged(String searchText) {
    debouncer.run(() {
      context.read<FetchAllbarberBloc>().add(SearchBarbersRequested(searchText.trim()));
  
    });


  }

  @override
  void dispose() {
    GlobalSearchController.searchController
        .removeListener(_handleControllerChange);
    _voiceSearchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _voiceSearchCubit),
       BlocProvider(create: (context) => GenderOptionCubit()),
       BlocProvider(create: (context) => SelectServiceCubit()),
       BlocProvider(create: (context) => RatingCubit()),
       BlocProvider(create: (context) => sl<FetchAdminServiceBloc>()..add(FetchAdminServiceRequested())),

       BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: BlocListener<VoiceSearchCubit, VoiceSearchState>(
        listener: (context, state) {
          if (state.hasError) {
            if (state.errorMessage == 'permission_denied') {
              _showPermissionDeniedDialog(context);
            } else {
              CustomSnackBar.show(
                context,
                message: state.errorMessage!,
                backgroundColor: AppPalette.redColor,
                durationSeconds: 4,
              );
            }
            _voiceSearchCubit.clearError();
          }
        },
      child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: AppDrawer(),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppPalette.orengeColor,
                backgroundColor: AppPalette.whiteColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: AppPalette.blackColor,
                      expandedHeight: screenHeight * 0.13,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        titlePadding: EdgeInsets.only(left: screenWidth * 0.04),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,vertical: screenHeight * 0.01),
                                child: BlocBuilder<VoiceSearchCubit,
                                    VoiceSearchState>(
                                  builder: (context, voiceState) {
                                    final isListening =  voiceState.isListening;
      
                                    return TextFormFieldWidget(
                                      hintText: 'Search shops...',
                                      prefixIcon: Icons.search,
                                      controller: GlobalSearchController.searchController,
                                      validate: ValidatorHelper.serching,
                                      fillClr: AppPalette.whiteColor,
                                      borderClr: AppPalette.blackColor,
                                      isfilterFiled: true,
                                      fillterAction: () {
                                          _scaffoldKey.currentState?.openDrawer();
                                      },
                                      onChanged: _onSearchChanged,
                                     suffixIconData: isListening
                                            ? Icons.mic_none_outlined
                                            : CupertinoIcons.mic_fill,
                                        suffixIconColor: isListening
                                            ? AppPalette.greenColor
                                            : AppPalette.greyColor,
                                      suffixIconAction: () {
                                        if (!isListening) {
                                            _startVoiceSearch();
                                          } else {
                                            _stopVoiceSearch();
                                          }
                                        },
                                      );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03, vertical: screenHeight * .01),
                      sliver:
                      BarberListBuilder(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}

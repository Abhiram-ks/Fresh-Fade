
import 'package:admin_pannel/core/di/di.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/themes/app_colors.dart';
import '../../widgets/service_widget/service_upload_widget.dart';

class ServiceScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ServiceScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FetchingServiceBloc>()),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Check if it's a large screen (web/tablet)
          bool isLargeScreen = screenWidth > 900;
          
          return isLargeScreen
              ? WebResponsiveServiceLayout(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                )
              : MobileServiceLayout(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                );
        },
      ),
    );
  }
}

// Mobile Layout (unchanged)
class MobileServiceLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const MobileServiceLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 600 ? screenWidth * .2 : screenWidth * 0.05,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          child: UploadServicesWidget(
            screenHight: screenHeight,
            screenWidth: screenWidth,
          ),
        ),
      ),
    );
  }
}

// Web Responsive Layout for Large Screens
class WebResponsiveServiceLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WebResponsiveServiceLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1200,
              minWidth: 800,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppPalette.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.blackColor.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppPalette.blueColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CupertinoIcons.settings,
                                color: AppPalette.blueColor,
                                size: 24,
                              ),
                            ),
                            ConstantWidgets.width20(context),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Service Management',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.blackColor,
                                    ),
                                  ),
                                  Text(
                                    'Manage your business services',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                       color: AppPalette.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ConstantWidgets.hight30(context),
                        buildInfoCard(
                          icon: CupertinoIcons.cloud_upload,
                          title: 'Upload Services',
                          description: 'Add new services to your business catalog',
                          color: AppPalette.greenColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        buildInfoCard(
                          icon: CupertinoIcons.pencil,
                          title: 'Edit Services',
                          description: 'Modify existing service details',
                          color: AppPalette.blueColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        buildInfoCard(
                          icon: CupertinoIcons.delete,
                          title: 'Remove Services',
                          description: 'Delete services from your catalog',
                          color: AppPalette.redColor,
                        ),
                        ConstantWidgets.hight20(context),
                        
                        // Tips Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPalette.blueColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppPalette.blueColor.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.lightbulb,
                                    color: AppPalette.blueColor,
                                    size: 20,
                                  ),
                                  Text(
                                    'Pro Tip',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppPalette.blueColor,
                                    ),
                                  ),
                                ],
                              ),
                              ConstantWidgets.hight10(context),
                              Text(
                                'Keep your service names clear and descriptive. This helps customers understand what you offer.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppPalette.greyColor,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: AppPalette.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.blackColor.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: UploadServicesWidget(
                            screenHight: screenHeight,
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  }



  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.blackColor,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppPalette.greyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }



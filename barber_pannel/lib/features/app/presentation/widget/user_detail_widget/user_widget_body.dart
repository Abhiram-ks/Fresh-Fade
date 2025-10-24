
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/widget/user_detail_widget/custom_functions.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_image.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';

class UserProfileBodyWIdget extends StatefulWidget {
  const UserProfileBodyWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
  });

  final double screenWidth;
  final double screenHeight;
  final String userId;

  @override
  State<UserProfileBodyWIdget> createState() => _UserProfileBodyWIdgetState();
}

class _UserProfileBodyWIdgetState extends State<UserProfileBodyWIdget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchUserBloc>().add(FetchUserRequest(userId: widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchUserBloc, FetchUserState>(
      builder: (context, state) {
        if (state is FetchUserLoading) {
          return Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                color: AppPalette.buttonColor,
                backgroundColor: AppPalette.hintColor,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (state is FetchUserLoaded) {
          final user = state.user;
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal:widget.screenWidth > 600 ? widget.screenWidth *.15 : widget.screenWidth * 0.05),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Dashboard',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  ConstantWidgets.hight10(context),
                  Text(
                    'Access essential client details and build stronger connections through seamless chat and contact features.',
                  ),
                  ConstantWidgets.hight20(context),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          color: AppPalette.greyColor,
                          width: 60,
                          height: 60,
                          child: user.photoUrl.startsWith('http')
                              ? imageshow(
                                  imageUrl: user.photoUrl,
                                  imageAsset: AppImages.appLogo)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    AppImages.appLogo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      ConstantWidgets.width20(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileviewWidget(
                            widget.screenWidth,
                            context,
                            Icons.verified,
                            user.email,
                            textColor: AppPalette.greyColor,
                            AppPalette.blueColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Personal Info',style: TextStyle(color: AppPalette.greyColor)),
                  ConstantWidgets.hight20(context),
                  Text('Full Name', style: TextStyle(color: AppPalette.buttonColor)),
                  Text(user.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Address',style: TextStyle(color: AppPalette.buttonColor)),
                  Text(user.address ?? "We're unable to display the address at this time.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight10(context),
                  Text('Age', style: TextStyle(color: AppPalette.buttonColor)),
                  Text(
                    user.age != null
                        ? '${user.age} years old'
                        : "We're unable to display the age at this time.",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ConstantWidgets.hight20(context),
                  Text('Communication & History',
                      style: TextStyle(color: AppPalette.greyColor)),
                  ConstantWidgets.hight20(context),
                  customerFunctions(
                      context: context,
                      screenWidth: widget.screenWidth,
                      barberID: state.barberId,
                      user: user),
                  ConstantWidgets.hight20(context),
                ],
              ),
            ),
          );
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.person),
            Text("We're unable to process your request at the moment."),
            Text('Try again later'),
            IconButton(
                onPressed: () {
                  context.read<FetchUserBloc>().add(FetchUserRequest(userId: widget.userId));
                },
                icon: Icon(CupertinoIcons.refresh)),
          ],
        ));
      },
    );
  }
}

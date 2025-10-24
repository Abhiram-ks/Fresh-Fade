import 'package:barber_pannel/core/common/custom_appbar2.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/injection_contains.dart';
import '../../../../../../core/themes/app_colors.dart';
import '../../../state/cubit/Like_comments_cubit/like_comments_cubit.dart';
import '../../../state/cubit/like_post_cubit/like_post_cubit.dart';
import '../../../state/cubit/share_cubit/share_cubit.dart';
import '../../../widget/post_widget/post_widget_body.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(    create: (context) => sl<FetchPostWithBarberBloc>()),
        BlocProvider(create: (_) => sl<LikePostCubit>()),
        BlocProvider(create: (_) => sl<LikeCommentCubit>()),
        BlocProvider(create: (_) => sl<ShareCubit>()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double heightFactor = 0.5;

          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar2(
                isTitle: true,
                title: 'Social & Entertainment',
                iconColor: AppPalette.blackColor,
              ),
              body: PostScreenWidget(
                  screenHeight: screenHeight,
                  heightFactor: heightFactor,
                  screenWidth: screenWidth),
            ),
          );
        },
      ),
    );
  }
}
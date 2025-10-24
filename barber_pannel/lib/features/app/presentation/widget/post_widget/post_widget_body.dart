import 'package:barber_pannel/features/app/data/model/post_with_barber_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'post_bloc_success_state_builder.dart';
import 'post_card_main_widget.dart';

class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
  });

  final double screenHeight;
  final double heightFactor;
  final double screenWidth;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostWithBarberBloc, FetchPostWithBarberState>(
      builder: (context, state) {
        if (state is FetchPostWithBarberLoaded) {
          final List<PostWithBarberModel> model = state.posts;
          return postBlocSuccessStateBuilder(commentController: commentController, context: context, heightFactor: widget.heightFactor,model: model, screenHeight: widget.screenHeight, screenWidth: widget.screenWidth,state: state);
        } else if (state is FetchPostWithBarberEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_size_select_actual_outlined, color: AppPalette.blackColor),
                const Text('No Posts Yet!', style: TextStyle(color: AppPalette.blackColor)),
                Text('Fresh styles coming soon! Add new posts.',
                    style: TextStyle(color: AppPalette.blackColor)),
                
              ],
            ),
          );
        } else if (state is FetchPostWithBarberError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_rounded,
                    color: AppPalette.blackColor),
                const Text('Something went wrong!'),
                Text('That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.blackColor)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequested());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.redColor),
                )
              ],
            ),
          );
        }

        // Shimmer loader state
        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyColor,
          highlightColor: AppPalette.greyColor,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostScreenMainWidget(
                isLiked: false,
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                description: 'Loading...',
                favoriteColor: AppPalette.redColor,
                favoriteIcon: Icons.favorite_border,
                likes: 0,
                likesOnTap: () {},
                commentOnTap: () {},
                location: 'Loading...',
                postUrl: '',
                profilePage: () {},
                shareOnTap: () {},
                shopName: 'Loading...',
                shopUrl: '',
                dateAndTime: '',
              );
            },
            separatorBuilder: (context, index) =>
                ConstantWidgets.hight10(context),
          ),
        );
      },
    );
  }

}

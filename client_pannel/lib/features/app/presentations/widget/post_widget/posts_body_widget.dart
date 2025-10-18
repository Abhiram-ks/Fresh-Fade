import 'package:client_pannel/features/app/presentations/widget/post_widget/post_body_main_widget.dart';
import 'package:client_pannel/features/app/presentations/widget/post_widget/post_success_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../data/model/post_with_barber_model.dart';
import '../../state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fech_post_with_barber_bloc.dart';

class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
    this.posts,
    this.userId,
  });

  final double screenHeight;
  final double heightFactor;
  final double screenWidth;
  final List<PostWithBarberModel>? posts;
  final String? userId;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<FechPostWithBarberBloc, FechPostWithBarberState>(
      builder: (context, state) {
         if (state is FetchPostWithBarberLoaded) {
          final List<PostWithBarberModel> model = state.posts;
          return postBlocSuccessStateBuilder(
            commentController: commentController,
             context: context, 
             heightFactor: widget.heightFactor,
             model: model, 
             screenHeight: widget.screenHeight, 
             screenWidth: widget.screenWidth,
             state: state);
        }
          if (state is FetchPostWithBarberEmpty) {
               return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_sharp,color: AppPalette.blackColor,size: 50,),
                const Text('No Posts Yet!',style: TextStyle(fontWeight: FontWeight.bold),),
                Text('No posts yet. Fresh styles coming soon!',
                    style: TextStyle(color: AppPalette.greyColor)),
              ],
            ),
          );
        } 
        else if (state is FetchPostWithBarberFailure) {
                   return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off,  color: AppPalette.blackColor,size: 50,),
                const Text('Something went wrong!',style: TextStyle(fontWeight: FontWeight.bold),),
                Text('Oops! That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.greyColor)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FechPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.redColor),
                )
              ],
            ),
          );
        }
     

        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyColor,
          highlightColor: AppPalette.whiteColor,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostScreenMainWidget(
                isLiked: false,
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                chatOnTap: () {},
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

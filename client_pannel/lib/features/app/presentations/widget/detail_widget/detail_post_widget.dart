
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';

import '../../../../../core/constant/constant.dart';
import '../../../../../core/images/app_images.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../screen/settings/settings_screen.dart';
import '../../state/bloc/fetch_bloc/fetch_barber_post_bloc/fetch_barber_post_bloc.dart';

class DetailPostWidget extends StatelessWidget {
  const DetailPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberPostBloc, FetchBarberPostState>(
    
      builder: (context, state) {
        if (state is FetchBarberPostLoading || state is FetchBarberPostInitial) {
          return loadingImage();
        } else if (state is FetchBarberPostFailure) {
          return Center(child: Text(state.error));
        } else if (state is FetchBarberPostEmpty) {
          return  Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.photo_fill_on_rectangle_fill	, size: 50,),
              ConstantWidgets.hight20(context),
              Text('No posts yet'),
            ],
          ));
        } 
        else if (state is FetchBarberPostSuccess) {
          return SingleChildScrollView(
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: PinchToZoomScrollableWidget(
                        child: imageshow(
                          imageUrl: post.imageUrl, 
                          imageAsset: AppImages.barberEmpty),
                      )
                    );
                  },
                ),
                ConstantWidgets.hight50(context),
                ConstantWidgets.hight50(context),
              ],
            ),
          );
        } 
        else {
          return loadingImage();
        }
      },
    );
  }

  Shimmer loadingImage() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300] ?? AppPalette.greyColor,
        highlightColor: AppPalette.whiteColor,
    child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.zero, 
                ),
                child: Image.asset(
                  AppImages.barberEmpty,
                  fit: BoxFit.cover, 
                ),
              );
            },
     ),
  );
  }
}

import 'package:barber_pannel/core/images/app_image.dart';
import 'package:barber_pannel/features/app/presentation/screens/setting/setting_screen.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/features/app/presentation/widget/settings_widget/taps_widgets/handle_delete_post_state.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/themes/app_colors.dart';

class TabbarImageShow extends StatelessWidget {
  const TabbarImageShow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostsBloc, FetchPostsState>(
      builder: (context, state) {
        if (state is FetchPostsLoading) {
          return loadingImage();
        } else if (state is FetchPostsEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No posts yet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "There are no posts yet. we have waiting for firs intial post.",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (state is FetchPostsLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 1,
            ),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];

              return BlocListener<DeletePostCubit, DeletePostState>(
                listener: (context, state) {
                  handleDeletePostsState(context, state);
                },
                child: InkWell(
                  onTap: () {
                    // Capture the cubit reference before opening the dialog
                    final deletePostCubit = context.read<DeletePostCubit>();
                    
                    showCupertinoModalPopup(
                      context: context,
                      builder:
                          (BuildContext content) => CupertinoActionSheet(
                            title: const Text(
                              'Delete Post',
                            ),
                            message: const Text(
                              'Are you sure you want to delete this post? This action cannot be undone.',
                            ),
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  deletePostCubit.deletePost(
                                      barberId: post.barberId,
                                      docId: post.postId);
                                  Navigator.pop(content);
                                },
                                isDestructiveAction: true,
                                child: const Text(
                                  'Delete for Post',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(content);
                                  Navigator.pushNamed(context, AppRoutes.post);
                                },
                                child: const Text(
                                  'View Post(s)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppPalette.blackColor,
                                  ),
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(content),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppPalette.blackColor,
                                ),
                              ),
                            ),
                          ),
                    );
                  },
                  child: imageshow(
                    imageUrl: post.imageUrl,
                    imageAsset: AppImages.appLogo,
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Something went wrong",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Unable to connect to the server. Please try again later.",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Shimmer loadingImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? AppPalette.greyColor,
      highlightColor: AppPalette.whiteColor,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
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
            child: Image.asset(AppImages.appLogo, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

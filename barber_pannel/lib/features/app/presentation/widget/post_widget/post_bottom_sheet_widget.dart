import 'package:barber_pannel/features/app/presentation/state/cubit/like_comments_cubit/like_comments_cubit.dart';
import 'package:barber_pannel/features/app/presentation/widget/post_widget/post_comments_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/di/injection_contains.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/data_time_formalt.dart';
import '../../../data/model/comment_model.dart';
import '../../state/bloc/fetch_bloc/fetch_comment_bloc/fetch_comment_bloc.dart';
import 'post_bloc_success_state_builder.dart' hide formatTimeRange;

void showCommentSheet({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String barberId,
  required String docId,
  required TextEditingController commentController,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppPalette.whiteColor,
    enableDrag: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(1.0)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return MultiBlocProvider(
        providers: [
          BlocProvider<FetchCommentBloc>(
            create: (context) {
              final bloc = sl<FetchCommentBloc>();
              bloc.add(FetchCommentRequest(docId: docId));
              return bloc;
            },
          ),
          BlocProvider<LikeCommentCubit>(
            create: (_) => sl<LikeCommentCubit>(),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: screenHeight,
            child: Column(
              children: [
                ConstantWidgets.hight10(context),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ConstantWidgets.hight10(context),
                Expanded(
                  child: BlocBuilder<FetchCommentBloc, FetchCommentState>(
                    builder: (context, state) {

                      if (state is FetchCommentLoading) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                                width: 15,
                                child:  CircularProgressIndicator(
                                  backgroundColor: AppPalette.buttonColor,
                                  color: AppPalette.whiteColor,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text('Loading comments...'),
                            ],
                          ),
                        );
                      }

                      if (state is FetchCommentsSuccess) {
                        if (state.comments.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConstantWidgets.hight50(context),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: AppPalette.buttonColor
                                        .withAlpha((0.3 * 255).round()),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "💬 No comments yet. Be the first to share your thoughts!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: state.comments.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final CommentModel comment = state.comments[index];
                            final formattedDate = formatDate(comment.createdAt);
                            final formattedStartTime = formatTimeRange(comment.createdAt);
                            return commentListWidget(
                              createdAt: '$formattedDate At $formattedStartTime',
                              favoriteColor: comment.likes.contains(state.barberID)
                                  ? AppPalette.redColor
                                  : AppPalette.blackColor,
                              favoriteIcon: comment.likes.contains(state.barberID)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              likesCount: comment.likes.length,
                              likesOnTap: () {
                                context.read<LikeCommentCubit>().toggleLike(
                                  barberId: barberId,
                                  docId: comment.docId,
                                  currentLikes: comment.likes,
                                );
                              },
                              context: context,
                              userName: comment.userName,
                              comment: comment.description,
                              imageUrl: comment.imageUrl,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              ConstantWidgets.hight10(context),
                        );
                      }
                      if (state is FetchCommentsError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstantWidgets.hight50(context),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.error_outline, color: Colors.red),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Failed to load comments',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red.shade700),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.error,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is FetchCommentEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstantWidgets.hight50(context),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppPalette.buttonColor
                                      .withAlpha((0.3 * 255).round()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "💬 No comments yet. Be the first to share your thoughts!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstantWidgets.hight50(context),
                            const Text('Unknown state'),
                            Text('State: ${state.toString()}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


import 'package:client_pannel/core/di/di.dart';
import 'package:client_pannel/features/app/domain/entity/comment_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_chat_window_textfiled.dart';
import '../../../../../core/constant/constant.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../../../service/formalt/time_date_formalt.dart';
import '../../../../auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../state/bloc/fetch_bloc/fetch_comments_bloc/fetch_comments_bloc.dart';
import '../../state/bloc/send_comment_bloc/send_comment_bloc.dart';
import '../../state/cubit/like_comments_cubit/like_comments_cubit.dart';
import 'handle_send_comment_state.dart';
import 'post_comment_list_widget.dart';

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
          BlocProvider(
            create: (context) => sl<FetchCommentsBloc>()
              ..add(FetchCommentRequst(barberId: barberId, docId: docId)),
          ),
          BlocProvider(
            create: (context) => sl<SendCommentBloc>(),
          ),
          BlocProvider(
            create: (context) => LikeCommentCubit(),
          ),
          BlocProvider(
            create: (context) => EmojiPickerCubit(),
          ),
          BlocProvider(
            create: (context) => ProgresserCubit(),
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
                  child: BlocBuilder<FetchCommentsBloc, FetchCommentsState>(

                    builder: (context, state) {
                      if (state is FetchCommentsLoading ) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  color: AppPalette.orengeColor,
                                  backgroundColor: AppPalette.hintColor,
                                  strokeWidth: 2,
                                ),
                              ),
                              ConstantWidgets.hight10(context),
                              Text('Just a moment...', style: TextStyle( fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                              Text('Please wait while we process your request', style: TextStyle( fontSize: 12), textAlign: TextAlign.center,),
                            ],
                          ),
                        );
                      } 
                      else if (state is FetchCommentsEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantWidgets.hight50(context),
                              Center(
                                  child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppPalette.orengeColor
                                      .withAlpha((0.3 * 255).round()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "💬 No comments yet. Be the first to start the conversation, your words are end-to-end encrypted, respected, and might just make someone's day. Share your thoughts, compliments, or experiences, let’s keep the good vibes rolling!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppPalette.blackColor),
                                ),
                              )),
                            ],
                          ),
                        );
                      }
                      if (state is FetchCommentsLoaded) {
                        return ListView.separated(
                          itemCount: state.comments.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final CommentEntity comment = state.comments[index];
                            final formattedDate = formatDate(comment.createdAt);
                            final formattedStartTime =
                                formatTimeRange(comment.createdAt);
                            return commentListWidget(
                                createdAt: '$formattedDate At $formattedStartTime',
                                favoriteColor:
                                    comment.likes.contains(state.userId)
                                        ? AppPalette.redColor
                                        : AppPalette.blackColor,
                                favoriteIcon:
                                    comment.likes.contains(state.userId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                likesCount: comment.likes.length,
                                likesOnTap: () {
                                  context.read<LikeCommentCubit>().toggleLike(
                                      userId: state.userId,
                                      docId: comment.docId,
                                      currentLikes: comment.likes);
                                },
                                context: context,
                                userName: comment.userName,
                                comment: comment.description,
                                imageUrl: comment.imageUrl);
                          },
                          separatorBuilder: (context, index) =>
                              ConstantWidgets.hight10(context),
                        );
                      }

                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                            CupertinoIcons.chat_bubble,
                              color: AppPalette.orengeColor,
                              size: 40,
                            ),
                            ConstantWidgets.hight10(context),
                            Text("Unable to complete the request.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            Text('Please try again later.', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
                            IconButton(
                                onPressed: () {
                                  context.read<FetchCommentsBloc>().add(FetchCommentRequst(barberId: barberId, docId: docId));
                                },
                                icon: Icon(Icons.refresh_rounded))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                BlocListener<SendCommentBloc, SendCommentState>(
                  listener: (context, state) {
                    handleSendComments(context, state, commentController);
                  },
                  child: Builder(
                    builder: (builderContext) {
                      return ChatWindowTextFiled(
                        controller: commentController,
                        isICon: false,
                        sendButton: () {
                          final text = commentController.text.trim();
                          if (text.isNotEmpty) {
                            builderContext.read<SendCommentBloc>().add(
                                SendCommentButtonPressed(
                                    comment: text,
                                    barberId: barberId,
                                    docId: docId));
                          }
                        },
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

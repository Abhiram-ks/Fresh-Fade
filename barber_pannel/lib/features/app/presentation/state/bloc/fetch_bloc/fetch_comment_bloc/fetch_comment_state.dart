part of 'fetch_comment_bloc.dart';

@immutable
abstract class FetchCommentState {}

class FetchCommentInitial extends FetchCommentState {}

class FetchCommentLoading extends FetchCommentState {}

class FetchCommentEmpty extends FetchCommentState {}

class FetchCommentsSuccess extends FetchCommentState {
  final List<CommentModel> comments;
  final String barberID;

  FetchCommentsSuccess({required this.comments, required this.barberID});
}

class FetchCommentsError extends FetchCommentState {
  final String error;

  FetchCommentsError({required this.error});
}
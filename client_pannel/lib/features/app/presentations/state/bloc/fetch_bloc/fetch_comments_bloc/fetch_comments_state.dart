part of 'fetch_comments_bloc.dart';

@immutable
abstract class FetchCommentsState {}

final class FetchCommentsInitial extends FetchCommentsState {}

final class FetchCommentsLoading extends FetchCommentsState {}

final class FetchCommentsEmpty extends FetchCommentsState {}

final class FetchCommentsLoaded extends FetchCommentsState {
  final List<CommentEntity> comments;
  final String userId;
  FetchCommentsLoaded({required this.comments, required this.userId});
}

final class FetchCommentsFailure extends FetchCommentsState {
  final String error;
  FetchCommentsFailure({required this.error});
}
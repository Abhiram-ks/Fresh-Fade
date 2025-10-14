part of 'fetch_posts_bloc.dart';

@immutable
abstract class FetchPostsState {}

final class FetchPostsInitial extends FetchPostsState {}

final class FetchPostsLoading extends FetchPostsState {}

final class FetchPostsEmpty extends FetchPostsState {}
final class FetchPostsLoaded extends FetchPostsState {
  final List<PostEntity> posts;

  FetchPostsLoaded({required this.posts});
}

final class FetchPostsError extends FetchPostsState {
  final String message;

  FetchPostsError({required this.message});
}
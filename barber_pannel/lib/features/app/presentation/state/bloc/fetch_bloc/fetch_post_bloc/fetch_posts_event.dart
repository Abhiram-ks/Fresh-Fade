part of 'fetch_posts_bloc.dart';

@immutable
abstract class FetchPostsEvent {}

final class FetchPostsRequest extends FetchPostsEvent {}

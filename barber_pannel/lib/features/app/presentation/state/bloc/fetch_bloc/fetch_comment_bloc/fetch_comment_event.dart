part of 'fetch_comment_bloc.dart';

@immutable
abstract class FetchCommentEvent {}

class FetchCommentRequest extends FetchCommentEvent {
  final String docId;

  FetchCommentRequest({required this.docId});
}
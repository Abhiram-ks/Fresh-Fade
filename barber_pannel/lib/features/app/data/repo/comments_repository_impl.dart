import '../../domain/repo/commets_repository.dart';
import '../datasource/comments_remote_datasource.dart';
import '../model/comment_model.dart';

class CommentsRepositoryImpl extends CommentsRepository {
  final CommentsRemoteDatasource commentsRemoteDatasource;

  CommentsRepositoryImpl({required this.commentsRemoteDatasource});

  @override
  Stream<List<CommentModel>> getComments({required String postDocId, required String barberID}) {
    print('Repository: Fetching comments for post $postDocId, barber $barberID');
    return commentsRemoteDatasource.getComments(postDocId: postDocId, barberID: barberID);
  }
}
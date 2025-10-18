import '../../domain/entity/comment_entity.dart';
import '../../domain/repo/comment_repo.dart';
import '../datasource/comment_remote_datasource.dart';

class SendCommentRepositoryImpl implements SendCommentRepository {
  final SendCommentRemoteDataSource remoteDatasource;

  SendCommentRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<CommentEntity>> fetchComments({
    required String barberId,
    required String docId,
  }) {
    try {
      return remoteDatasource.fetchComments(
        barberId: barberId,
        docId: docId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sendComment({
    required String userId,
    required String comment,
    required String docId,
    required String barberId,
  }) async {
    try {
      return await remoteDatasource.sendComment(
        userId: userId,
        comment: comment,
        docId: docId,
        barberId: barberId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

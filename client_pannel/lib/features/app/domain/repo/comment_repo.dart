import '../entity/comment_entity.dart';

abstract class SendCommentRepository {
  Stream<List<CommentEntity>> fetchComments({
    required String barberId,
    required String docId,
  });
  
  Future<bool> sendComment({
    required String userId,
    required String comment,
    required String docId,
    required String barberId,
  });
}


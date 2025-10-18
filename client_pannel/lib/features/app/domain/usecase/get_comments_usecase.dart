import '../entity/comment_entity.dart';
import '../repo/comment_repo.dart';

class GetCommentsUseCase {
  final SendCommentRepository repository;

  GetCommentsUseCase({required this.repository});

  Stream<List<CommentEntity>> call({
    required String barberId,
    required String docId,
  }) {
    return repository.fetchComments(
      barberId: barberId,
      docId: docId,
    );
  }
}


import '../repo/comment_repo.dart';

class SendCommentUseCase {
  final SendCommentRepository repository;

  SendCommentUseCase({required this.repository});

  Future<bool> call({
    required String userId,
    required String comment,
    required String docId,
    required String barberId,
  }) {
    return repository.sendComment(
      userId: userId,
      comment: comment,
      docId: docId,
      barberId: barberId,
    );
  }
}


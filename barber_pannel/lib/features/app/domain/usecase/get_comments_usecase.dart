import '../../data/model/comment_model.dart';
import '../repo/commets_repository.dart';

class GetCommentsUsecase {
  final CommentsRepository commentsRepository;

  GetCommentsUsecase({required this.commentsRepository});

  Stream<List<CommentModel>> call({required String postDocId, required String barberID}) {
    return commentsRepository.getComments(postDocId: postDocId, barberID: barberID);
  }
}
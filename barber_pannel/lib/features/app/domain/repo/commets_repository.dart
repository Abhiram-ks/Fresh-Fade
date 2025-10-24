import 'package:barber_pannel/features/app/data/model/comment_model.dart';

abstract class CommentsRepository {

  Stream<List<CommentModel>> getComments({required String postDocId, required String barberID});
}
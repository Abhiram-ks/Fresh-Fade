import 'package:barber_pannel/features/app/data/model/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsRemoteDatasource {
  final FirebaseFirestore firestore;

  CommentsRemoteDatasource({required this.firestore});

  Stream<List<CommentModel>> getComments({required String postDocId, required String barberID}) {
    try {
     

      return firestore
        .collection('comments')
        .where('postDocId', isEqualTo: postDocId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) {
            return [];
          }

          final commentDocs = snapshot.docs;
          final commentModels = await Future.wait(commentDocs.map((doc) async {
            final commentData = doc.data();
            final userId = commentData['userId'] as String?;

            if (userId == null || userId.isEmpty) {
              return CommentModel.fromData(
                commentData: commentData,
                userData: {'name': 'Unknown', 'photoUrl': ''},
              );
            }

            try {
              final userSnapshot = await firestore.collection('users').doc(userId).get();

              final userData = userSnapshot.exists
                  ? userSnapshot.data() ?? {}
                  : {'name': 'Unknown', 'photoUrl': ''};

              return CommentModel.fromData(
                commentData: commentData,
                userData: userData,
              );
            } catch (e) {
              return CommentModel.fromData(
                commentData: commentData,
                userData: {'userName': 'Unknown', 'image': ''},
              );
            }
          }));
          return commentModels;
        });
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }
}
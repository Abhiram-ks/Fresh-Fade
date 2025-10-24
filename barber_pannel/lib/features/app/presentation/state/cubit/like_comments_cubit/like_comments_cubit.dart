import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeCommentCubit extends Cubit<void> {
  final FirebaseFirestore firestore;

  LikeCommentCubit({required this.firestore}) : super(null);

  Future<void> toggleLike({
    required String barberId,
    required String docId,
    required List<String> currentLikes,
  }) async {
    final commentDoc = firestore
      .collection('comments')
      .doc(docId);

   final isLiked = currentLikes.contains(barberId);
    try {
      await commentDoc.update({
        'likes' : isLiked 
            ? FieldValue.arrayRemove([barberId])
            : FieldValue.arrayUnion([barberId])
      });
    } catch (e) {
      rethrow;
    }
  }
}
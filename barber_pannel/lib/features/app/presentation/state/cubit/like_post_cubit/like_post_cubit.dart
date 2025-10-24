import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikePostCubit extends Cubit<void> {
  final FirebaseFirestore firestore;
  LikePostCubit({required this.firestore}) : super(null);


  Future<void> likePost({
    required String barberId,
    required String postId,
    required List<String> curretLikes,
  }) async {
    final postRef = firestore
    .collection('posts')
    .doc(barberId)
    .collection('Post')
    .doc(postId);

    final isLiked = curretLikes.contains(barberId);

    try {
      await postRef.update({
        'likes' : isLiked 
          ? FieldValue.arrayRemove([barberId])
          : FieldValue.arrayUnion([barberId]),
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
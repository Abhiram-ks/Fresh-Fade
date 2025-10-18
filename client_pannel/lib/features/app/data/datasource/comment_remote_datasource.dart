import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/comment_model.dart';

class SendCommentRemoteDataSource {
  final FirebaseFirestore firestore;
  
  SendCommentRemoteDataSource({required this.firestore});


  
//! fetch comments
  Stream<List<CommentModel>> fetchComments({
    required String barberId,
    required String docId,
  }) {
    try {
      
    return firestore
        .collection('comments')
        .where('postDocId', isEqualTo: docId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) return [];

          final commentDocs = snapshot.docs;
          final commentModels = await Future.wait(commentDocs.map((doc) async {
            final commentData = doc.data();

            final userId = commentData['userId'];
            final userSnapshot = await firestore.collection('users').doc(userId).get();

            final userData = userSnapshot.exists
                ? userSnapshot.data() ?? {}
                : {'name': 'Unknown', 'photoUrl': ''};
            return CommentModel.fromData(
              commentData: commentData,
              userData: userData,
            );
          }));
          log('commentModels: ${commentModels.map((e) => e.userName)}');
          return commentModels;
        });
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  //! send comments
  Future<bool> sendComment({
    required String userId,
    required String comment,
    required String docId,
    required String barberId,
  }) async {
    try {
      final postDocRef = firestore.collection('comments').doc(); // Auto-generated ID

      await postDocRef.set({
        'docId': postDocRef.id,             
        'postDocId': docId,               
        'userId': userId,
        'barberId': barberId,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(), 
        'likes': [],                             
      });

      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PostRemoteDatasource {
  final FirebaseFirestore firestore;

  PostRemoteDatasource({required this.firestore}); 

  Future<bool> uploadPost({
    required String barberId,
    required String imageUrl,
    required String description,
  }) async {
    try {
      final postRef = firestore
          .collection('posts')
          .doc(barberId)
          .collection('Post')
          .doc();

          await postRef.set({
            'image': imageUrl,
            'description': description,
            'likes': [],
            'comments': {},
            'createdAt': FieldValue.serverTimestamp(),
          });
        return true;
    } catch (e) {
      throw Exception();
    }
  }
}
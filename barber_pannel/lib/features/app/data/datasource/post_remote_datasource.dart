import 'package:barber_pannel/features/app/data/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRemoteDatasource {
  final FirebaseFirestore firestore;

  PostRemoteDatasource({required this.firestore}); 
  
  /// Upload a post to the database
  /// 
  /// @param barberId: The ID of the barber who is uploading the post
  /// @param imageUrl: The URL of the image to be uploaded
  /// @param description: The description of the post
  /// @return: True if the post is uploaded successfully, false otherwise
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

  /// Get all posts from the database
  /// 
  /// @param barberId: The ID of the barber who is getting the posts
  /// @return: A list of posts
  Stream<List<PostModel>> getPosts({required String barberId}) async*  {
    try {
      final postsRef = firestore
      .collection('posts')
      .doc(barberId)
      .collection('Post')
      .orderBy('createdAt', descending: true);

      yield* postsRef.snapshots().map((snapshop) {
        return snapshop.docs.map((doc) {
          return PostModel.fromMap(barberId, doc);
        }).toList();
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
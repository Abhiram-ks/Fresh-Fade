import 'package:barber_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../model/post_with_barber_model.dart';

class PostRemoteDatasource {
  final FirebaseFirestore firestore;
  final BarberRemoteDatasource barberRemoteDatasource;

  PostRemoteDatasource({required this.firestore, required this.barberRemoteDatasource}); 
  
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

  /// Delete a post from the database
  /// 
  /// @param barberId: The ID of the barber who is deleting the post
  /// @param docId: The ID of the post to be deleted
  /// @return: True if the post is deleted successfully, false otherwise
  Future<bool> deletePost({required String barberId, required String docId}) async {
    try {
      await firestore.collection('posts')
          .doc(barberId)
          .collection('Post')
          .doc(docId).delete();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // Get all posts with barber data
  //  
  Stream<List<PostWithBarberModel>> getPostsWithBarber({required String barberId}) {
    try {
      return barberRemoteDatasource.streamBarber(barberId).switchMap((
        barber) {
          final postRef = firestore
          .collection('posts')
          .doc(barber.uid)
          .collection('Post')
          .orderBy('createdAt', descending: true);

          return postRef.snapshots().map((snapshot) {
            return snapshot.docs.map((doc) {
              final post = PostModel.fromMap(barber.uid, doc);
              return PostWithBarberModel(post: post, barber: barber);
            }).toList();
          });
        }
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
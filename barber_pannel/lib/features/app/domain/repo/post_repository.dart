import 'package:barber_pannel/features/app/data/model/post_with_barber_model.dart';
import 'package:barber_pannel/features/app/domain/entity/post_entity.dart';

abstract class PostRepository {
  Future<bool> uploadPost({
    required String barberId,
    required String imageUrl,
    required String description,
  });

  Stream<List<PostEntity>> getPosts({
    required String barberId,
  });


  Future<bool> deletePost({required String barberId, required String docId});

  /// Get posts with barber
  /// 
  /// @param barberId: The barber's unique ID
  /// @return A stream of lists of PostWithBarberModel
  /// @throws Exception if the operation fails
  Stream<List<PostWithBarberModel>> getPostsWithBarber({required String barberId});
}


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
}


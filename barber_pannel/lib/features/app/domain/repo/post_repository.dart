abstract class PostRepository {
  Future<bool> uploadPost({
    required String barberId,
    required String imageUrl,
    required String description,
  });
}


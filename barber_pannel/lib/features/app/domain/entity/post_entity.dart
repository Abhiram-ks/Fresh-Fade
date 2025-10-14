class PostEntity {
  final String barberId;
  final String postId;
  final String imageUrl;
  final String description;
  final List<String> likes;
  final Map<String, String> comments;
  final DateTime createdAt;

  PostEntity({
    required this.barberId,
    required this.postId,
    required this.imageUrl,
    required this.description,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });
}


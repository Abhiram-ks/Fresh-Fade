class CommentEntity {
  final String userId;
  final String docId;
  final String postDocId;
  final String barberId;
  final String description;
  final List<String> likes;
  final String userName;
  final String imageUrl;
  final DateTime createdAt;

  const CommentEntity({
    required this.userId,
    required this.docId,
    required this.postDocId,
    required this.barberId,
    required this.description,
    required this.likes,
    required this.userName,
    required this.imageUrl,
    required this.createdAt,
  });
}

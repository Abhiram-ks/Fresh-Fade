
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.barberId,
    required super.postId,
    required super.imageUrl,
    required super.description,
    required super.likes,
    required super.comments,
    required super.createdAt,
  });

  factory PostModel.fromDocument(String barberId, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      barberId: barberId,
      postId: doc.id,
      imageUrl: data['image'] ?? '',
      description: data['description'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      comments: Map<String, String>.from(data['comments'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': imageUrl,
      'description': description,
      'likes': likes,
      'comments': comments,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  PostEntity toEntity() => PostEntity(
        barberId: barberId,
        postId: postId,
        imageUrl: imageUrl,
        description: description,
        likes: likes,
        comments: comments,
        createdAt: createdAt,
      );

  factory PostModel.fromEntity(PostEntity entity) => PostModel(
        barberId: entity.barberId,
        postId: entity.postId,
        imageUrl: entity.imageUrl,
        description: entity.description,
        likes: entity.likes,
        comments: entity.comments,
        createdAt: entity.createdAt,
      );
}
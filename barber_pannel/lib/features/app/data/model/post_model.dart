import 'package:barber_pannel/features/app/domain/entity/post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.barberId,
    required super.postId,
    required super.imageUrl,
    required super.description,
    required super.likes,
    required super.comments,
    required super.createdAt,
  });


  factory PostModel.fromMap(String barberId, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      barberId: barberId,
      postId: doc.id,
      imageUrl: data['image'] ?? '',
      description: data['description'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      comments: Map<String, String>.from(data['comments'] ?? {}),
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}
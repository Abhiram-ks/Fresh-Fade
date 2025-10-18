import 'package:client_pannel/features/app/domain/entity/comment_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.userId,
    required super.docId,
    required super.postDocId,
    required super.barberId,
    required super.description,
    required super.likes,
    required super.userName,
    required super.imageUrl,
    required super.createdAt,
  });

  /// Convert Firestore document to CommentModel
  factory CommentModel.fromData({
    required Map<String, dynamic> commentData,
    required Map<String, dynamic> userData,
  }) {
    return CommentModel(
      userId: commentData['userId'] ?? '',
      docId: commentData['docId'] ?? '',
      postDocId: commentData['postDocId'] ?? '',
      barberId: commentData['barberId'] ?? '',
      description: commentData['comment'] ?? '',
      likes: List<String>.from(commentData['likes'] ?? []),
      userName: userData['name'] ?? '',
      imageUrl: userData['photoUrl'] ?? '',
      createdAt: (commentData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert CommentModel to Map (for saving/updating Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'docId': docId,
      'postDocId': postDocId,
      'barberId': barberId,
      'comment': description,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Convert to Entity
  CommentEntity toEntity() {
    return CommentEntity(
      userId: userId,
      docId: docId,
      postDocId: postDocId,
      barberId: barberId,
      description: description,
      likes: likes,
      userName: userName,
      imageUrl: imageUrl,
      createdAt: createdAt,
    );
  }
}

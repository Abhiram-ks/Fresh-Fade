
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    super.docId,
    required super.senderId,
    required super.userId,
    required super.barberId,
    required super.message,
    required super.createdAt,
    required super.updatedAt,
    required super.isSee,
    required super.delete,
    required super.softDelete,
  });

  /// Create Model from Firestore Map
  factory ChatModel.fromMap(String docId, Map<String, dynamic> map) {
    return ChatModel(
      docId: docId,
      senderId: map['senderId'] ?? '',
      userId: map['userId'] ?? '',
      barberId: map['barberId'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updateAt'] as Timestamp).toDate(),
      isSee: map['isSee'] ?? false,
      delete: map['delete'] ?? false,
      softDelete: map['softDelete'] ?? false,
    );
  }

  /// Convert Model → Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'userId': userId,
      'barberId': barberId,
      'message': message,
      'createdAt': createdAt,
      'updateAt': updatedAt,
      'isSee': isSee,
      'delete': delete,
      'softDelete': softDelete,
    };
  }

  /// Convert Entity → Model
  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      docId: entity.docId,
      senderId: entity.senderId,
      userId: entity.userId,
      barberId: entity.barberId,
      message: entity.message,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSee: entity.isSee,
      delete: entity.delete,
      softDelete: entity.softDelete,
    );
  }

  /// Convert Model → Entity
  ChatEntity toEntity() {
    return ChatEntity(
      docId: docId,
      senderId: senderId,
      userId: userId,
      barberId: barberId,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSee: isSee,
      delete: delete,
      softDelete: softDelete,
    );
  }
}
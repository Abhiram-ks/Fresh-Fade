import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/wishlist_entity.dart';

class WishlistModel extends WishlistEntity {
  const WishlistModel({
    required super.userId,
    required super.shopId,
    required super.likedAt,
  });

  /// Factory constructor to create a model from Firestore document data
  factory WishlistModel.fromMap(Map<String, dynamic> data) {
    return WishlistModel(
      userId: data['userId'] ?? '',
      shopId: data['shopId'] ?? '',
      likedAt: (data['likedAt'] as Timestamp).toDate(),
    );
  }

  /// Converts model to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shopId': shopId,
      'likedAt': Timestamp.fromDate(likedAt),
    };
  }

  /// Converts model to pure entity (useful for repository/domain layers)
  WishlistEntity toEntity() => WishlistEntity(userId: userId, shopId: shopId, likedAt: likedAt);

  /// Creates model from entity (useful for saving)
  factory WishlistModel.fromEntity(WishlistEntity entity) => WishlistModel(
    userId: entity.userId,
    shopId: entity.shopId,
    likedAt: entity.likedAt,
  );
}

class WishlistEntity {
  final String userId;
  final String shopId;
  final DateTime likedAt;

  const WishlistEntity({
    required this.userId,
    required this.shopId,
    required this.likedAt,
  });

  WishlistEntity copyWith({
    String? userId,
    String? shopId,
    DateTime? likedAt,
  }) {
    return WishlistEntity(
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      likedAt: likedAt ?? this.likedAt,
    );
  }
}
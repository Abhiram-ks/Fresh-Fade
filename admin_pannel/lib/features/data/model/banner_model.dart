import '../../domain/entity/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.imageUrls,
    required super.index,
  });

  /// Convert Firestore / JSON → Model
  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      imageUrls: List<String>.from(map['image_urls'] ?? []),
      index: map['index'] ?? 0,
    );
  }

  /// Convert Model → Map (for Firestore / JSON)
  Map<String, dynamic> toMap() {
    return {
      'image_urls': imageUrls,
      'index': index,
    };
  }

  /// Optional: Clone with updated values
  BannerModel copyWith({
    List<String>? imageUrls,
    int? index,
  }) {
    return BannerModel(
      imageUrls: imageUrls ?? this.imageUrls,
      index: index ?? this.index,
    );
  }
}
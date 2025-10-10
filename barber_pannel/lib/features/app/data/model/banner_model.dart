import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';

class BannerModel extends BannerEntity {
  BannerModel({
    required super.index,
    required super.bannerImage,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      index: map['index'] ?? 0,
      bannerImage: List<String>.from(map['image_urls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_urls': bannerImage,
      'index': index,
    };
  }

  BannerEntity toEntity() {
    return BannerEntity(
      index: index,
      bannerImage: bannerImage,
    );
  }
}
import 'package:flutter/widgets.dart';

@immutable
class BannerEntity {
  final List<String> imageUrls;
  final int index;

  const BannerEntity({
    required this.imageUrls,
    required this.index,
  });
}

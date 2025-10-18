
import '../entity/banner_entity.dart';

abstract class BannerRepository {
  Stream<BannerEntity> streamBanners();
}


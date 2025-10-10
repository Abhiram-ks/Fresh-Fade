import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';

abstract class BannerRepository {
  Stream<BannerEntity> streamBanners();
}


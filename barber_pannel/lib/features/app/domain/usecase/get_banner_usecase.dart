import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/banner_repository.dart';

class GetBannerUseCase {
  final BannerRepository repository;

  GetBannerUseCase({required this.repository});

  Stream<BannerEntity> call() {
    return repository.streamBanners();
  }
}


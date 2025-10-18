import '../entity/banner_entity.dart';
import '../repo/banner_repo.dart';

class GetBannerUseCase {
  final BannerRepository repository;

  GetBannerUseCase({required this.repository});

  Stream<BannerEntity> call() {
    return repository.streamBanners();
  }
}

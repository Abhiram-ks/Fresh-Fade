import 'package:admin_pannel/features/domain/entity/banner_entity.dart';
import 'package:admin_pannel/features/domain/repo/banner_repo.dart';

class FetchBarberBannerUsecase {
  final BannerRepository repository;

  FetchBarberBannerUsecase(this.repository);

  Stream<BannerEntity> execute() {
    try {
      return repository.getBarberBannerStream();
    } catch (e) {
      rethrow;
    }
  }
}

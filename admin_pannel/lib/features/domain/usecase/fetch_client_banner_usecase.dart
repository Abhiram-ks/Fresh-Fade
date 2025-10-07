import 'package:admin_pannel/features/domain/domain/banner_entity.dart';
import 'package:admin_pannel/features/domain/repo/banner_repo.dart';

class FetchClientBannerUsecase {
  final BannerRepository repository;

  FetchClientBannerUsecase(this.repository);

  Stream<BannerEntity> execute() {
    try {
      return repository.getClientBannerStream();
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:admin_pannel/features/domain/repo/banner_repo.dart';
import 'package:admin_pannel/features/domain/domain/banner_entity.dart';
import '../datasource/banner_remote_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDatasource dataSource;

  BannerRepositoryImpl({required this.dataSource});

  @override
  Stream<BannerEntity> getClientBannerStream() {
    try {
      return dataSource.getClientBannerStream().map((bannerModel) {
        return BannerEntity(
          imageUrls: bannerModel.imageUrls,
          index: bannerModel.index,
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<BannerEntity> getBarberBannerStream() {
    try {
      return dataSource.getBarberBannerStream().map((bannerModel) {
        return BannerEntity(
          imageUrls: bannerModel.imageUrls,
          index: bannerModel.index,
        );
      });
    } catch (e) {
      rethrow;
    }
  }
}

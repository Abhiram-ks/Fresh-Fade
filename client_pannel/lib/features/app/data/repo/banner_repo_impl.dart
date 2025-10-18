import '../../domain/entity/banner_entity.dart';
import '../../domain/repo/banner_repo.dart';
import '../datasource/banner_remote_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDatasource remoteDatasource;

  BannerRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<BannerEntity> streamBanners() {
    try {
      return remoteDatasource.banner().map((bannerModel) => bannerModel.toEntity());
    } catch (e) {
      throw Exception('Failed to stream banners: $e');
    }
  }
}


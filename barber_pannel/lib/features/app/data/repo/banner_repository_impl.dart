import 'package:barber_pannel/features/app/data/datasource/banner_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/entity/banner_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/banner_repository.dart';

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


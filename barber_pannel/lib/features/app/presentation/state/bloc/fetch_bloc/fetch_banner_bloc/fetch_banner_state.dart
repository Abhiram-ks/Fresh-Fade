part of 'fetch_banner_bloc.dart';

@immutable
abstract class FetchBannerState {}

final class FetchBannerInitial extends FetchBannerState {}

final class FetchBannersLoading extends FetchBannerState {}
final class FetchBannersEmpty extends FetchBannerState {}
final class FetchBannersLoaded extends FetchBannerState {
  final BannerEntity banners;

  FetchBannersLoaded(this.banners);
}

final class FetchBannersFailure extends FetchBannerState {
  final String bannerUrl;

  FetchBannersFailure(this.bannerUrl);
}

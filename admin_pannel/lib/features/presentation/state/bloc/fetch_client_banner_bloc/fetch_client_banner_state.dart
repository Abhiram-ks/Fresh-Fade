part of 'fetch_client_banner_bloc.dart';

@immutable

abstract class FetchUserBannerState {}

final class FetchUserBannerInitial extends FetchUserBannerState{}
final class FetchUserBannerLoading extends FetchUserBannerState {}
final class UserBannerLoadedState extends FetchUserBannerState {
  final BannerEntity userBanner;
  UserBannerLoadedState(this.userBanner);
}
class FetchingBannerUserErrorState  extends FetchUserBannerState{
  final String error;
  FetchingBannerUserErrorState(this.error);
}

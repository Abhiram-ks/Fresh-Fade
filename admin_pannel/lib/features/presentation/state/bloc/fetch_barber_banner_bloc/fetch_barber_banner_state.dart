part of 'fetch_barber_banner_bloc.dart';

@immutable
abstract class FetchBannerBarberState {}

final class FetchBannerBarberInitial extends FetchBannerBarberState {}
final class FetchBarberBannerLoading extends FetchBannerBarberState {}
final class BarberBannerLoadedState  extends FetchBannerBarberState{
  final BannerEntity barberBanner;
  BarberBannerLoadedState(this.barberBanner);
}
final class BarberBannerEmptyState  extends FetchBannerBarberState{}
class FetchingBannerBarberErrorState  extends FetchBannerBarberState{
  final String error;
  FetchingBannerBarberErrorState(this.error);
}
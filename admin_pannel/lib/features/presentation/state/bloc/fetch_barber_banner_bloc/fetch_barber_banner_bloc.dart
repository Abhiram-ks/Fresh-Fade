import 'package:admin_pannel/features/domain/entity/banner_entity.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_barber_banner_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'fetch_barber_banner_event.dart';
part 'fetch_barber_banner_state.dart';

class FetchBannerBarberBloc extends Bloc<FetchBannerBarberEvent, FetchBannerBarberState> {
  final FetchBarberBannerUsecase fetchBarberBannerUsecase;
  
  FetchBannerBarberBloc(this.fetchBarberBannerUsecase) : super(FetchBannerBarberInitial()) {
    on<FetchBarberBannerAction>((event, emit) async {
      try {
        emit(FetchBarberBannerLoading());
        await emit.forEach(
          fetchBarberBannerUsecase.execute(),
          onData: (barberBanner) => BarberBannerLoadedState(barberBanner),
          onError: (error, stackTrace) {
            return FetchingBannerBarberErrorState('Failed to fetch barber banners: $error');
          });
      } catch (e) {
        emit(FetchingBannerBarberErrorState('Failed to fetch barber banners: $e'));
      }
    });
  }
}

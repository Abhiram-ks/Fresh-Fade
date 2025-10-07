import 'package:admin_pannel/features/domain/domain/banner_entity.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_client_banner_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
part 'fetch_client_banner_event.dart';
part 'fetch_client_banner_state.dart';

class FetchUserBannerBloc extends Bloc<FetchUserBannerEvent, FetchUserBannerState> {
  final FetchClientBannerUsecase fetchClientBannerUsecase;

  FetchUserBannerBloc(this.fetchClientBannerUsecase) : super(FetchUserBannerInitial()) {
    on<FetchUserBannerAction>((event, emit) async {
      try {
        emit(FetchUserBannerLoading());
        await emit.forEach(
          fetchClientBannerUsecase.execute(),
          onData: (userBanner) => UserBannerLoadedState(userBanner),
          onError: (error, stackTrace) {
            return FetchingBannerUserErrorState('Failed to fetch user banner: $error');
          },
        );
      } catch (e) {
        emit(FetchingBannerUserErrorState('Failed to fetch user banners: $e'));
      }
    });
  }
}

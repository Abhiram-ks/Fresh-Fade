

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../domain/entity/banner_entity.dart';
import '../../../../../domain/usecase/get_banner_usecase.dart';
part 'fetch_banner_event.dart';
part 'fetch_banner_state.dart';


class FetchBannersBloc extends Bloc<FetchBannerEvent, FetchBannerState> {
  final GetBannerUseCase useCase;

  FetchBannersBloc({required this.useCase}) : super(FetchBannerInitial()) {
    on<FetchBannersRequest>(_onFetchBannersRequest);
  }

  Future<void> _onFetchBannersRequest(
    FetchBannersRequest event,
    Emitter<FetchBannerState> emit,
  ) async {
    emit(FetchBannersLoading());
    try {
      await emit.forEach<BannerEntity>(
        useCase(),
        onData: (banner) {
          if (banner.bannerImage.isEmpty) {
            return FetchBannersEmpty();
          } else {
            return FetchBannersLoaded(banner);
          }
        },
        onError: (error, stackTrace) {
          return FetchBannersFailure('Failed to fetch banners: $error');
        },
      );
    } catch (e) {
      emit(FetchBannersFailure('Unexpected error: $e'));
    }
  }
}


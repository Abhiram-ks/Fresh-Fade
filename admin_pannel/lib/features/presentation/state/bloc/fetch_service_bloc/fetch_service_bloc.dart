import 'package:admin_pannel/features/domain/domain/service_entity.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_service_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
part 'fetch_service_event.dart';
part 'fetch_service_state.dart';

class FetchingServiceBloc extends Bloc<FetchServiceEvent, FetchServiceState> {
  final FetchServiceUsecase fetchServiceUsecase;
  
  FetchingServiceBloc(this.fetchServiceUsecase) : super(FetchingServiceInitial()) {
    on<FetchServiceDataEvent>((event, emit) async {
      emit(ServiceLoadingState());
      await emit.forEach(
        fetchServiceUsecase.execute(),
        onData: (services) {
          if (services.isEmpty) {
            emit(ServiceEmptyState());
          }
          return ServiceLoadedState(services);
        },
        onError: (error, stackTrace) {
          return ServiceFechingErrorState('Failed to fetch service: $error');
        },
      );
    });
  }
}
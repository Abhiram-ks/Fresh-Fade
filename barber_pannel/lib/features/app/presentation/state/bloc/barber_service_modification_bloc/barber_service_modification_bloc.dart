import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../domain/usecase/updated_barber_service_usecase.dart';

part 'barber_service_modification_event.dart';
part 'barber_service_modification_state.dart';

class BarberServiceModificationBloc extends  Bloc<BarberServiceModificationEvent, BarberServiceModificationState> {
  String barberID = '';
  String serviceKey = '';
  double serviceRate = 0;
  double oldServiceRate = 0;

  final ModificationBarberUsecase usecase;
  BarberServiceModificationBloc({required this.usecase})
    : super(BarberServiceModificationInitial()) {
    // delete service event
    on<DeleteServiceEventRequest>((event, emit) {
      barberID = event.barberID;
      serviceKey = event.serviceKey;
      emit(BarberServiceModificationDeleteAlert(serviceName: serviceKey));
    });

    //! delete service event confirm
    on<DeleteServiceEventConfirm>((event, emit) async {
      emit(BarberServiceModificationLoading());
      try {
        final bool response = await usecase.deleteService(
          barberId: barberID,
          serviceName: serviceKey,
        );
        emit(
          BarberServiceModificationLoaded(
            message: 'Service deleted successfully',
          ),
        );

        if (response) {
          emit(BarberServiceModificationLoaded(message: 'Service Deleted'));
        } else {
          emit(
            BarberServiceModificationError(message: 'Service deletion failed'),
          );
        }
      } catch (e) {
        emit(BarberServiceModificationError(message: e.toString()));
      }
    });

    //! update service event
    on<FetchBarberServiceUpdateRequestEvent>((event, emit) {
      barberID = event.barberID;
      serviceKey = event.serviceKey;
      serviceRate = event.serviceRate;
      oldServiceRate = event.oldServiceRate;
      emit(
        BarberServiceModificationUpdateAlert(
          serviceName: serviceKey,
          oldServiceRate: serviceRate.toString(),
          serviceRate: serviceRate.toString(),
        ),
      );
    });


    //! update service event confirm
    on<FetchBarberServiceUpdateConfirmEvent>((event, emit) async {
      emit(BarberServiceModificationLoading());
      try {
        if (serviceRate.toString() == oldServiceRate.toString()) {
          emit(BarberServiceModificationError(message: 'Service rate is the same'));
          return;
        }
        final bool response = await usecase.updateService(barberId: barberID, serviceName: serviceKey, serviceRate: serviceRate);
        
        if (response) {
          emit(BarberServiceModificationLoaded(message: 'Service Updated'));
        } else {
          emit(
            BarberServiceModificationError(message: 'Service update failed'),
          );
        }
      } catch (e) {
        emit(BarberServiceModificationError(message: e.toString()));
      }
    });
  }
}

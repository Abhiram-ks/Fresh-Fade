import 'package:barber_pannel/features/app/domain/usecase/upload_barber_service_usecase.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'barber_service_event.dart';
part 'barber_service_state.dart';

class BarberServiceBloc extends Bloc<BarberServiceEvent, BarberServiceState> {
  String serviceName = '';
  double serviceRate = 0.0;

  final AuthLocalDatasource localDB;
  final UploadBarberServiceUseCase usecase;
  BarberServiceBloc({required this.localDB, required this.usecase}) : super(BarberServiceInitial()) {
    on<AddBarberServiceEvent>((event, emit) {
      serviceName = event.serviceName;
      serviceRate = event.serviceRate;
      emit(BarberServiceConfirmationAlertState(serviceName, serviceRate));
    });


    on<BarberServiceConfirmationEvent>((event, emit)  async{
      emit(BarberServiceLoading());
       try { 

         final String? barberID = await localDB.get();
         if(barberID == null){
          emit(BarberServiceFailure('Barber shop token expired please login again'));
          return;
         }
         final result = await usecase(serviceName: serviceName, serviceRate: serviceRate, barberId: barberID);

         if(result){
          emit(BarberServiceSuccess());
         }else{
          emit(BarberServiceFailure('Failed to add service'));
         }
       } on Exception catch (e) { 
         emit(BarberServiceFailure(e.toString()));
       } catch (e) {
        emit(BarberServiceFailure(e.toString()));
       }
    });
  }
}

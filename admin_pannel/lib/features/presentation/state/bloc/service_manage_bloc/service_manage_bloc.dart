import 'package:admin_pannel/features/domain/usecase/service_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'service_manage_event.dart';
part 'service_manage_state.dart';

class ServiceMangementBloc extends Bloc<ServiceMangementEvent, ServiceMangementState> {
  final ServiceManagementUsecase repo;

  String _serviceId = '';
  String _serviceName = '';

  String get serviceId => _serviceId;
  String get serviceName => _serviceName;

  ServiceMangementBloc({required this.repo}) : super(ServiceMangementInitial()) {
    on<UploadNewServiceEvent>((event, emit) async {
      try {
        emit(ServiceManagementLoaded());
        final isUploaded = await repo.excutedUpload(event.serviceName);

        if (isUploaded) {
          emit(UploadServiceSuccessState());
        } else {
           emit(ServiceErrorState(error: 'An unexpected error occurred while uploading the service.'));
        }
      } catch (e) {
          emit(ServiceErrorState(error: 'Failed to upload service. Error details: $e'));
      }
    });

      on<DeleteServiceEvent>((event, emit) {
    _serviceId = event.serviceId;
    emit(ShowDeleteServiceAlert());
  });
   
   on<DeleteConfirmation>((event, emit)async {
    try {
     final response = await repo.excutedDelete(serviceId: _serviceId);
     if (response) {
       emit(DeleteServiceConfirmationSuccess());
     } else { 
       emit(ServiceErrorState(error: 'Unexpected Error occured'));
     }
    } catch (e) {
      emit(ServiceErrorState(error: 'Error: $e'));
    }

   });

   on<EditServiceEvent>((event, emit) {
     _serviceId = event.serviceId;
     _serviceName = event.serviceName;
    emit(ShowEditServiceTestFeld(event.serviceName)); 
   });

   on<UpdateServiceEvent>((event, emit) async{
     try {
       final reponse = await repo.excutedUpdate(serviceId: _serviceId, updatedService: event.updatedText);
       if (reponse) {
         emit(EditServiceSuccessState());
       } else {
          emit(ServiceErrorState(error: 'Unexpected Error occured'));
       }
     } catch (e) {
          emit(ServiceErrorState(error: 'Updation failed Error: $e'));       
     }
   });
  }
}

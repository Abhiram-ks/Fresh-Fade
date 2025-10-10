import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecase/update_barber_status_usecase.dart';
part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final UpdateBarberStatusUsecase usecase;
  String _fullName = '';
  String _ventureName = '';
  String _id = '';

  String get fullName => _fullName;
  String get ventureName => _ventureName;
  String get id => _id;

  RequestBloc({required this.usecase}) : super(RequestInitial()) {

    //! isAccept
    on<AcceptAction>((event, emit) {
      _fullName = event.name;
      _ventureName = event.ventureName;
      _id = event.id;
      emit(AcceptAlertState(name: _fullName, ventureName: _ventureName));
    });

    //! isAccept confirmation
    on<AcceptConfirmation>((event, emit) async {
      try {
        final response = await usecase.accept(barberId: _id);
        emit(response ? RequestSuccessState() : RequestErrorState(error: 'Failed to accept barber'));
      } catch (e) {
        emit(RequestErrorState(error: 'Failed to accept barber: $e'));
      }
    });


   // Reject section events and states
    //! isReject
    on<RejectAction>((event, emit) {
      _fullName = event.name;
      _ventureName = event.ventureName;
      _id = event.id;
      emit(RejectAlertState(name: _fullName, ventureName: _ventureName));
    });

    //! isReject confirmation
    on<RejectConfirmation>((event, emit) async{
      try {
        final reponse = await usecase.reject(barberId: _id);
        emit(reponse ? RequestSuccessState() : RequestErrorState(error: 'Failed to reject barber'));
      } catch (e) {
        emit(RequestErrorState(error: 'Failed to reject barber: $e'));
      }
    });

  }
}

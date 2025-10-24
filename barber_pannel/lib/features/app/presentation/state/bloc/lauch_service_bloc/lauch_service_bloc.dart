import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../service/laucher/launcher_service.dart';
part 'lauch_service_event.dart';
part 'lauch_service_state.dart';

class LauchServiceBloc extends Bloc<LauchServiceEvent, LauchServiceState> {
  String? name;
  String? email;
  String? subject;
  String? body;
  LauchServiceBloc() : super(LauchServiceInitial()) {
    on<LauchServiceAlertBoxEvent>((event, emit) {
      name = event.name;
      email = event.email;
      subject = event.subject;
      body = event.body;
      emit(LauchServiceAlertBox());
    });

    on<LauchServiceConfirmEvent>((event, emit)async {
      emit(LauchServiceLoading());

      try {
        if (name == null || email == null || subject == null || body == null) {
          throw Exception('Data syncing correction find it unable to launch email');
        }
        final bool response = await LauncerService.openEmail(name: name ?? '', email: email ?? '', subject: subject ?? '', body: body ?? '');
        if (response) {
          emit(LauchServiceAlertBoxSuccess());
        } else {
          throw Exception('Unable to launch email');
        }
      } catch (e) {
        emit(LauchServiceAlertBoxError(error: e.toString()));
      }
    });
  }
}

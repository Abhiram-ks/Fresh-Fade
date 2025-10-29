import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../service/launcher/launcher_service.dart';
part 'launcher_service_event.dart';
part 'launcher_service_state.dart';

class LauncherServiceBloc extends Bloc<LauncherServiceEvent, LauncherServiceState> {
  LauncherServiceBloc() : super(LauncherServiceInitial()) {
    String? name;
    String? email;
    String? subject;
    String? body;

    on<LauncherServiceAlertEvent>((event, emit) {
      name = event.name;
      email = event.email;
      subject = event.subject;
      body = event.body;
      emit(LauncherServiceAlertBox());
    });


    on<LauncherServiceConfirmEvent>((event, emit)async {
      emit(LauncherServiceLoading());

      try {
        if (name == null || email == null || subject == null || body == null) {
          throw Exception('Data syncing correction find it unable to launch email');
        }
        final bool response = await LauncerService.openEmail(name: name ?? '', email: email ?? '', subject: subject ?? '', body: body ?? '');
        if (response) {
          emit(LauncherServiceSuccess());
        } else {
          emit(LauncherServiceFailure(error: 'Unable to launch email'));
        }
      } catch (e) {
        emit(LauncherServiceFailure(error: e.toString()));
      }
    });
  }
}

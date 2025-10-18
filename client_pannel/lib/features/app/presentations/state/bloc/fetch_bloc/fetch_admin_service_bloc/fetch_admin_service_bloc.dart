import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_admin_service_event.dart';
part 'fetch_admin_service_state.dart';

class FetchAdminServiceBloc extends Bloc<FetchAdminServiceEvent, FetchAdminServiceState> {
  FetchAdminServiceBloc() : super(FetchAdminServiceInitial()) {
    on<FetchAdminServiceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

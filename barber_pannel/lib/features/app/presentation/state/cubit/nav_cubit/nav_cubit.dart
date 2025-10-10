import 'package:bloc/bloc.dart';


enum NavItem {home, revenue, service, chat, profile}

class ButtomNavCubit extends Cubit<NavItem> {
  ButtomNavCubit() : super(NavItem.home);
  
  void selectItem (NavItem item) {
    emit(item);
  }
}

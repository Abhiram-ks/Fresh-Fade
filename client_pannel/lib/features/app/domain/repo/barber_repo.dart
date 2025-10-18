import '../../data/model/barber_model.dart';

abstract class BarberRepository {
  Stream<List<BarberModel>> streamAllBarbers();
  Stream<BarberModel> streamBarber(String barberId);
}


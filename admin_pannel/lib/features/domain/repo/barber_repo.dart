import '../entity/barber_entity.dart';

abstract class BarberRepository {
  // Fetch All Barbers
  Stream<List<BarberEntity>> getAllBarbersStream();

  // Accept & Reject Barber
  Future<bool> acceptBarber({required String barberId});
  Future<bool> rejectBarber({required String barberId});

  // Bloc & UnBloc Barber
  Future<bool> updateBlocAndUnBloc({required String uid, required bool val});
}


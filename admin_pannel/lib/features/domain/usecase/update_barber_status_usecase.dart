import '../repo/barber_repo.dart';

class UpdateBarberStatusUsecase {
  final BarberRepository repository;

  UpdateBarberStatusUsecase({required this.repository});
  

  //! Accept Barber
  Future<bool> accept({required String barberId}) async {
    return await repository.acceptBarber(barberId: barberId);
  }
  
  //! Reject Barber
  Future<bool> reject({required String barberId}) async {
    return await repository.rejectBarber(barberId: barberId);
  }

  //! Bloc & UnBloc Barber
  Future<bool> updateBlocAndUnBloc({required String uid, required bool val}) async {
    return await repository.updateBlocAndUnBloc(uid: uid, val: val);
  }
}
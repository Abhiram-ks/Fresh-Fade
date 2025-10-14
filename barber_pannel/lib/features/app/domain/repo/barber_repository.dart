import 'package:barber_pannel/features/auth/domain/entity/barber_entity.dart';

abstract class BarberRepository {
  Stream<BarberEntity> streamBarber(String barberId);
  
  Future<bool> updateBarber({
    required String uid,
    String? barberName,
    String? ventureName,
    String? phoneNumber,
    String? address,
    String? image,
    int? age,
  });


  //upload new field
  Future<bool> uploadNewField({
    required String uid,
    required String imageUrl,
    required String gender,
  });
}


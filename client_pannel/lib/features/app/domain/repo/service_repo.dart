import 'package:client_pannel/features/app/domain/entity/barber_service_entity.dart';

import '../entity/admin_service_entity.dart';

abstract class ServiceRepository {
  /// Stream of admin services from Firebase
  Stream<List<AdminServiceEntity>> streamAdminServices();

  /// Stream of barber services from Firebase
  Stream<List<BarberServiceEntity>> streamBarberServices({required String barberId});
}


import 'package:barber_pannel/features/app/domain/entity/service_entity.dart';

abstract class ServiceRepository {
  Stream<List<ServiceEntity>> streamServices();
}


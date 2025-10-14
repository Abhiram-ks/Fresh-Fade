import '../../domain/entity/barber_service_entity.dart';

class BarberServiceModel extends BarberServiceEntity {
  BarberServiceModel({
    required super.id,
    required super.serviceName,
    required super.serviceRate,
  });

  factory BarberServiceModel.fromJson(Map<String, dynamic> json) {
    return BarberServiceModel(
      id: json['barberId'],
      serviceName: json['serviceName'],
      serviceRate: json['amount'],
    );
  } 
  factory BarberServiceModel.fromMap({
    required String barberID,
    required String key,
    required dynamic value,
  }) {
    return BarberServiceModel(
      id: barberID,
      serviceName: key,
      serviceRate: (value as num).toDouble(),
    );
  }


  BarberServiceEntity toEntity() {
    return BarberServiceEntity(
      id: id,
      serviceName: serviceName,
      serviceRate: serviceRate,
    );
  }

  factory BarberServiceModel.fromEntity(BarberServiceEntity entity) {
    return BarberServiceModel(
      id: entity.id,
      serviceName: entity.serviceName,
      serviceRate: entity.serviceRate,
    );
  }
}

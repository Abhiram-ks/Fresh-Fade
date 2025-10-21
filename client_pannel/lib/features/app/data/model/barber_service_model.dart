
import '../../domain/entity/barber_service_entity.dart';


class BarberServiceModel extends BarberServiceEntity {
  const BarberServiceModel({
    required super.barberId,
    required super.serviceName,
    required super.amount,
  });

  /// Convert Model → Map (for Firestore/JSON)
  Map<String, dynamic> toMap() {
    return {
      'barberId': barberId,
      'serviceName': serviceName,
      'amount': amount,
    };
  }

  /// Convert Map → Model
  factory BarberServiceModel.fromMap({
    required String barberID,
    required String key,
    required dynamic value,
  }) {
    return BarberServiceModel(
      barberId: barberID,
      serviceName: key,
      amount: (value as num).toDouble(),
    );
  }

  /// Convert Entity → Model
  factory BarberServiceModel.fromEntity(BarberServiceEntity entity) {
    return BarberServiceModel(
      barberId: entity.barberId,
      serviceName: entity.serviceName,
      amount: entity.amount,
    );
  }

  /// Convert Model → Entity
  BarberServiceEntity toEntity() {
    return BarberServiceEntity(
      barberId: barberId,
      serviceName: serviceName,
      amount: amount,
    );
  }
}
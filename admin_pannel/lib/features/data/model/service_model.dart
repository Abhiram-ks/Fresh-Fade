
import 'package:admin_pannel/features/domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
  });

  factory ServiceModel.fromFirestore(Map<String, dynamic> data) {
    return ServiceModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
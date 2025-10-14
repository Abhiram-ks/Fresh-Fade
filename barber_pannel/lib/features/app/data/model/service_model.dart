import 'package:barber_pannel/features/app/domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
   ServiceModel({
    required super.id,
    required super.name,
  });

  factory ServiceModel.fromMap(String id, Map<String, dynamic> data) {
    return ServiceModel(
      id: id, 
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  ServiceEntity toEntity() => ServiceEntity(id: id, name: name);

  @override
  factory ServiceModel.fromEntity(ServiceEntity entity) => ServiceModel(id: entity.id, name: entity.name);
}
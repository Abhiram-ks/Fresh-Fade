import 'package:client_pannel/features/app/domain/entity/admin_service_entity.dart';

class AdminServiceModel extends AdminServiceEntity {
  const AdminServiceModel({
    required super.id,
    required super.name,
  });

  /// Factory constructor to create from Firestore or API Map
  factory AdminServiceModel.fromMap(String documentId, Map<String, dynamic> data) {
    return AdminServiceModel(
      id: documentId,
      name: data['name'] ?? '',
    );
  }

  /// Convert to Map for uploading to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }


  factory AdminServiceModel.fromEntity(AdminServiceEntity entity) {
    return AdminServiceModel(
      id: entity.id,
      name: entity.name,
    );
  }

  /// Convert back to Entity (if needed in domain layer)
  AdminServiceEntity toEntity() {
    return AdminServiceEntity(
      id: id,
      name: name,
    );
  }
}
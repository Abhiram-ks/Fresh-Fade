class UserEntity {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String? phone;
  final String? address;
  final int? age;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.phone,
    this.address,
    this.age,
    required this.createdAt,
    required this.updatedAt,
  });
}
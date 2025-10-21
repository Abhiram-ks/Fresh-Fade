class ChatEntity {
  final String? docId;
  final String senderId;
  final String userId;
  final String barberId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSee;
  final bool delete;
  final bool softDelete;

  const ChatEntity({
    this.docId,
    required this.senderId,
    required this.userId,
    required this.barberId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isSee,
    required this.delete,
    required this.softDelete,
  });
}

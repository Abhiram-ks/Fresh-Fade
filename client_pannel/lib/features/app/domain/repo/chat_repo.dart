import '../entity/barber_entity.dart';

abstract class ChatRepository {
  /// Stream of barbers that the user has chats with
  Stream<List<BarberEntity>> streamChats({required String userId});
}


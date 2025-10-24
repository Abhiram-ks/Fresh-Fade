import 'package:barber_pannel/features/app/data/model/chat_model.dart';
import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import '../entity/chat_entity.dart';

abstract class ChatRepository {
  Stream<List<UserEntity>> getChatUsers({required String barberId});

  //Last message data
  Stream<ChatEntity?> latestMessage({required String userId, required String barberId});

  //Message badges
  Stream<int> messageBadges({required String userId, required String barberId});

  //Update status for chats
  Future<void> chatStatusChange({required String userId, required String barberId});

  //! send to chat
  Future<bool> send({required ChatModel chat});

  
}
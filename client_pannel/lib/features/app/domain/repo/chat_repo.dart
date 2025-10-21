import 'package:client_pannel/features/app/domain/entity/chat_entity.dart';

import '../../data/model/chat_model.dart';
import '../entity/barber_entity.dart';

abstract class ChatRepository {
  /// Stream of barbers that the user has chats with
  Stream<List<BarberEntity>> streamChats({required String userId});

  //! update chat status
  Future<void> updateChatStatus({required String userId, required String barberId});

  //! send message
  Future<bool> sendMessage({required ChatModel message});

  //! fetch last message
  Stream<ChatEntity?> latestMessage({required String userId, required String barberId});

  //! fetch number of messages
  Stream<int> messageBadges({required String userId, required String barberId});
}


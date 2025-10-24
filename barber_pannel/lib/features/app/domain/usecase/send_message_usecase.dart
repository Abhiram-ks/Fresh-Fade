import '../../data/model/chat_model.dart';
import '../repo/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository chatRepository;

  SendMessageUsecase({required this.chatRepository});

  Future<bool> sendMessage({required ChatModel message}) {
    return chatRepository.send(chat: message);
  }
}


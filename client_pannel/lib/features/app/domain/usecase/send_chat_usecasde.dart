import '../../data/model/chat_model.dart';
import '../repo/chat_repo.dart';

class SendChatUsecase {
  final ChatRepository chatRepository;

  SendChatUsecase({required this.chatRepository});

  Future<bool> call({required ChatModel message}) async {
    return await chatRepository.sendMessage(message: message);
  }
}
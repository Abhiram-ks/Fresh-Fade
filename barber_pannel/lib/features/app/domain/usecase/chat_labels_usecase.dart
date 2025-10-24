import '../entity/chat_entity.dart';
import '../repo/chat_repository.dart';

class ChatLabelsUsecase {
  final ChatRepository chatRepository;

  ChatLabelsUsecase({required this.chatRepository});

  Stream<ChatEntity?> call({required String userId, required String barberId}) {
    return chatRepository.latestMessage(userId: userId, barberId: barberId);
  }

  Stream<int> execute({required String userId, required String barberId}) {
    return chatRepository.messageBadges(userId: userId, barberId: barberId);
  }


  Future<void> chatStatusChange({required String userId, required String barberId}) async {
    await chatRepository.chatStatusChange(userId: userId, barberId: barberId);
  }
}
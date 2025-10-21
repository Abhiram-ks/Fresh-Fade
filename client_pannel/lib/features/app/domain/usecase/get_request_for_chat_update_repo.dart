import '../repo/chat_repo.dart';

class GetRequestForChatUpdateUseCase {
  final ChatRepository chatRepository;
  GetRequestForChatUpdateUseCase(this.chatRepository);

  Future<void> call({required String userId, required String barberId}) async {
    await chatRepository.updateChatStatus(userId: userId, barberId: barberId);
  }
}
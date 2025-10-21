import 'package:client_pannel/features/app/domain/repo/chat_repo.dart';

import '../entity/chat_entity.dart';

class GetLastMessageUsecase {
  final ChatRepository chatRepository;

  GetLastMessageUsecase({required this.chatRepository});

  Stream<ChatEntity?> call(String userId, String barberId) {
    return chatRepository.latestMessage(userId: userId, barberId: barberId);
  }
}
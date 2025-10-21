import 'package:client_pannel/features/app/domain/repo/chat_repo.dart';

class GetMessageBadgeUsecase {
  final ChatRepository chatRepository;

  GetMessageBadgeUsecase({required this.chatRepository});

  Stream<int> call(String userId, String barberId) {
    return chatRepository.messageBadges(userId: userId, barberId: barberId);
  }
}
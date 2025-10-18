import '../entity/barber_entity.dart';
import '../repo/chat_repo.dart';

class StreamChatsUseCase {
  final ChatRepository repository;

  StreamChatsUseCase({required this.repository});

  Stream<List<BarberEntity>> call({required String userId}) {
    return repository.streamChats(userId: userId);
  }
}


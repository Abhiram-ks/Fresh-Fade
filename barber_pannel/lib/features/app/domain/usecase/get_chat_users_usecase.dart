import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/chat_repository.dart';

class GetChatUsersUsecase {
  final ChatRepository repository;

  GetChatUsersUsecase({required this.repository});

  Stream<List<UserEntity>> call({required String barberId}) {
    return repository.getChatUsers(barberId: barberId);
  }
}


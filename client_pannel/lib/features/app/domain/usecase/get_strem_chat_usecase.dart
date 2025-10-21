import 'package:client_pannel/features/app/domain/entity/barber_entity.dart';
import 'package:client_pannel/features/app/domain/repo/post_repo.dart';

class GetStremChatUseCase {
  final PostRepository repository;

  GetStremChatUseCase({required this.repository});

  Stream<List<BarberEntity>> call({required String userId}) {
    return repository.streamChatCall(userId: userId);
  }
}
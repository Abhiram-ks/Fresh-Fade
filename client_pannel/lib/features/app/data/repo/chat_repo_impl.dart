import '../../domain/entity/barber_entity.dart';
import '../../domain/repo/chat_repo.dart';
import '../datasource/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<BarberEntity>> streamChats({required String userId}) {
    try {
      return remoteDatasource.streamChats(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}


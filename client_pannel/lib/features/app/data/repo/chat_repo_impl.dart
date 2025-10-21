import 'package:client_pannel/features/app/domain/entity/chat_entity.dart';

import '../../domain/entity/barber_entity.dart';
import '../../domain/repo/chat_repo.dart';
import '../datasource/chat_remote_datasource.dart';
import '../model/chat_model.dart';

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

  @override
  Future<void> updateChatStatus({required String userId, required String barberId}) async {
    try {
      await remoteDatasource.updateChatStatus(userId: userId, barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<bool> sendMessage({required ChatModel message}) async {
    try {
      return await remoteDatasource.sendMessage(message: message);
    } catch (e) {
      rethrow;
    }
  }


  @override
  Stream<ChatEntity?> latestMessage({required String userId, required String barberId}) {
    try {
      return remoteDatasource.latestMessage(userId: userId, barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<int> messageBadges({required String userId, required String barberId}) {
    try {
      return remoteDatasource.messageBadges(userId: userId, barberId: barberId);
    } catch (e) {
      rethrow;
    }
  }
}


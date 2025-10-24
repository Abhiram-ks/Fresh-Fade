import 'package:barber_pannel/features/app/data/model/chat_model.dart';
import 'package:barber_pannel/features/app/domain/entity/user_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/chat_repository.dart';

import '../../domain/entity/chat_entity.dart';
import '../datasource/chat_remote_datasource.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;

  ChatRepositoryImpl({
    required this.chatRemoteDatasource,
  });

  @override
  Stream<List<UserEntity>> getChatUsers({required String barberId}) {
    return chatRemoteDatasource.getChatUsers(barberId: barberId);
  }

  @override
  Stream<ChatEntity?> latestMessage({required String userId, required String barberId}) {
    return chatRemoteDatasource.latestMessage(userId: userId, barberId: barberId);
  }

  @override
  Stream<int> messageBadges({required String userId, required String barberId}) {
    return chatRemoteDatasource.messageBadges(userId: userId, barberId: barberId);
  }


  @override
  Future<void> chatStatusChange({required String userId, required String barberId}) {
    return chatRemoteDatasource.chatStatusChange(userId: userId, barberId: barberId);
  }

  @override
  Future<bool> send({required ChatModel chat}){
    return chatRemoteDatasource.sendMessage(message: chat);
  }
}

import 'package:barber_pannel/features/app/domain/usecase/chat_labels_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusChatRequstDartCubit extends Cubit<StatusChatRequstState> {
  final ChatLabelsUsecase repository;
  StatusChatRequstDartCubit(this.repository) : super(StatusChatRequstInitial());

  Future<void> updateChatStatus({
    required String userId,
    required String barberId
  }) async {
    await repository.chatStatusChange(userId: userId, barberId: barberId);
  }
}


abstract class StatusChatRequstState {}
final class StatusChatRequstInitial extends StatusChatRequstState {}
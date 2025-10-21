
import 'package:client_pannel/features/app/domain/usecase/get_request_for_chat_update_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusChatRequstDartCubit extends Cubit<StatusChatRequstState> {
  final GetRequestForChatUpdateUseCase usecase;
  StatusChatRequstDartCubit({required this.usecase}) : super(StatusChatRequstInitial());

  Future<void> updateChatStatus({
    required String userId,
    required String barberId
  }) async {
    await usecase.call(userId: userId, barberId: barberId);
  }
}


abstract class StatusChatRequstState {}
final class StatusChatRequstInitial extends StatusChatRequstState {}
import '../repo/post_repository.dart';

class DeletePostUsecase {
  final PostRepository postRepository;

  DeletePostUsecase({required this.postRepository});

  Future<bool> call({required String barberId, required String docId}) async {
    return await postRepository.deletePost(barberId: barberId, docId: docId);
  }
}
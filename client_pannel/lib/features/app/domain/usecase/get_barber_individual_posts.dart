import '../entity/post_entity.dart';
import '../repo/post_repo.dart';

class GetBarberIndividualPostsUseCase {
  final PostRepository repository;

  GetBarberIndividualPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call(String barberId) {
    return repository.fetchBarberIndividualPosts(barberId);
  }
}
import '../../data/model/post_with_barber_model.dart';
import '../repo/post_repo.dart';

class GetPostsWithBarbersUseCase {
  final PostRepository repository;

  GetPostsWithBarbersUseCase({required this.repository});

  Stream<List<PostWithBarberModel>> call() {
    return repository.fetchAllPostsWithBarbers();
  }
}


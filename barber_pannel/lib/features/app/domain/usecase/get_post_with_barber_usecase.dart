import '../../data/model/post_with_barber_model.dart';
import '../repo/post_repository.dart';

class GetPostWithBarberUsecase {
  final PostRepository postRepository;

  GetPostWithBarberUsecase({required this.postRepository});

  Stream<List<PostWithBarberModel>> call(String barberId) {
    return postRepository.getPostsWithBarber(barberId: barberId);
  }
}
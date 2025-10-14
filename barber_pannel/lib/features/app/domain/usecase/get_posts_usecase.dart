import 'package:barber_pannel/features/app/domain/entity/post_entity.dart';
import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call({required String barberId}) {
    return repository.getPosts(barberId: barberId);
  }
}


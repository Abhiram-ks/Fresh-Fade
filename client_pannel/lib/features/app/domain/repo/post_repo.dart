import '../../data/model/post_with_barber_model.dart';

abstract class PostRepository {
  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers();
}


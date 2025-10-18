import '../../domain/repo/post_repo.dart';
import '../datasource/post_remote_datasource.dart';
import '../model/post_with_barber_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers() {
    try {
      return remoteDatasource.fetchAllPostsWithBarbers();
    } catch (e) {
      throw Exception('Failed to fetch posts with barbers: $e');
    }
  }
}


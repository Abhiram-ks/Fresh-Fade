import 'package:barber_pannel/features/app/data/datasource/post_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({required this.remoteDatasource});

  @override
  Future<bool> uploadPost({
    required String barberId,
    required String imageUrl,
    required String description,
  }) async {
    try {
      return await remoteDatasource.uploadPost(
        barberId: barberId,
        imageUrl: imageUrl,
        description: description,
      );
    } catch (e) {
      throw Exception('Failed to upload post: $e');
    }
  }
}


import 'package:barber_pannel/features/app/data/datasource/post_remote_datasource.dart';
import 'package:barber_pannel/features/app/domain/entity/post_entity.dart';
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
      rethrow;
    }
  }

  @override
  Stream<List<PostEntity>> getPosts({required String barberId}) {
    try {
      return remoteDatasource.getPosts(barberId: barberId).map((postModels) {
        return postModels.map((model) => model as PostEntity).toList();
      });
    } catch (e) {
      rethrow;
    }
  }
}


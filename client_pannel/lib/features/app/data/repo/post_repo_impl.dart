import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/repo/post_repo.dart';
import '../datasource/post_remote_datasource.dart';
import '../model/post_with_barber_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({required this.remoteDatasource});
  

  //Fetch all posts with barbers
  @override
  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers() {
    try {
      return remoteDatasource.fetchAllPostsWithBarbers();
    } catch (e) {
      rethrow;
    }
  }
 

  //Fetch barber individual posts
  @override
  Stream<List<PostEntity>> fetchBarberIndividualPosts(String barberId) {
    try {
      return remoteDatasource.fetchBarberIndividualPosts(barberId);
    } catch (e) {
       rethrow;
    }
  }

  // stream chat
  @override
  Stream<List<BarberEntity>> streamChatCall({required String userId}) {
    try {
      return remoteDatasource.streamChat(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}


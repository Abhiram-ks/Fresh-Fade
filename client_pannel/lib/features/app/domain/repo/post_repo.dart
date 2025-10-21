import 'package:client_pannel/features/app/domain/entity/post_entity.dart';

import '../../data/model/post_with_barber_model.dart';
import '../entity/barber_entity.dart';

abstract class PostRepository {
  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers();
  
  Stream<List<PostEntity>> fetchBarberIndividualPosts(String barberId);
  
  // stream chat
  Stream<List<BarberEntity>> streamChatCall({required String userId});
}


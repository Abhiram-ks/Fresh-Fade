
import '../../../auth/data/model/barber_model.dart';
import 'post_model.dart';

class PostWithBarberModel {
  final PostModel post;
  final BarberModel barber;

  PostWithBarberModel({
    required this.post,
    required this.barber,
  });
}
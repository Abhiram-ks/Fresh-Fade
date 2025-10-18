import 'package:client_pannel/features/app/data/model/barber_model.dart';
import 'package:client_pannel/features/app/data/model/post_model.dart';

class PostWithBarberModel {
  final PostModel post;
  final BarberModel barber;

  PostWithBarberModel({
    required this.post,
    required this.barber,
  });
}
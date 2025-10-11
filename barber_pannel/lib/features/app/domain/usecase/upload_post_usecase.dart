import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';

class UploadPostUseCase {
  final PostRepository repository;

  UploadPostUseCase({required this.repository});

  Future<bool> call({
    required String barberId,
    required String imageUrl,
    required String description,
  }) {
    return repository.uploadPost(
      barberId: barberId,
      imageUrl: imageUrl,
      description: description,
    );
  }
}


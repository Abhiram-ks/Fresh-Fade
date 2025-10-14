import 'package:barber_pannel/features/app/domain/repo/barber_service_repository.dart';

class UploadBarberServiceUseCase {
  final BarberServiceRepository repository;

  UploadBarberServiceUseCase({required this.repository});

  Future<bool> call({
    required String barberId,
    required String serviceName,
    required double serviceRate,
  }) {
    return repository.uploadService(
      barberId: barberId,
      serviceName: serviceName,
      serviceRate: serviceRate,
    );
  }
}


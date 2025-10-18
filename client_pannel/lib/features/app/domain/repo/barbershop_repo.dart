import '../../data/model/barbershop_entity.dart';

abstract class BarbershopServicesRepository {
  Future<List<BarberShopData>> fetchNearbyBarberShops(double lat, double lng, int around);
}
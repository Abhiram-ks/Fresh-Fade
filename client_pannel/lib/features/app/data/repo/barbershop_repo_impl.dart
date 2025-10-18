import '../../domain/repo/barbershop_repo.dart';
import '../model/barbershop_entity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/barbershop_model.dart';

class GetNearbyBarberShops {
  final BarbershopServicesRepository repository;
  GetNearbyBarberShops(this.repository);

  Future<List<BarberShopData>> call(double lat, double lng, int around) {
    return repository.fetchNearbyBarberShops(lat, lng, around);
  }
}


class BarberShopRepositoryImpl implements BarbershopServicesRepository {
  @override
  Future<List<BarberShopData>> fetchNearbyBarberShops(double lat, double lng, int around) async {
    final query = '''
      [out:json];
      (
        node["shop"="hairdresser"](around:$around,$lat,$lng);
        way["shop"="hairdresser"](around:$around,$lat,$lng);
      );
      out body;
      >;
      out skel qt;
    ''';

    final url = Uri.parse('https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List elements = jsonData['elements'];

      return elements
          .where((e) => e['lat'] != null && e['lon'] != null)
          .map<BarberShopData>((e) => BarberShopModel.fromOverpassJson(e, lat, lng))
          .toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      throw Exception('Failed to fetch nearby barber shops');
    }
  }
}
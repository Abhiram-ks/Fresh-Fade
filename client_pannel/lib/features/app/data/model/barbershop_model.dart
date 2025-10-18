
import 'package:latlong2/latlong.dart';
import 'barbershop_entity.dart';

class BarberShopModel extends BarberShopData {
  BarberShopModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.name,
    required super.address,
    required super.distance,
  });

  factory BarberShopModel.fromOverpassJson(Map<String, dynamic> json, double userLat, double userLng) {
    final distance = const Distance().as(
      LengthUnit.Kilometer,
      LatLng(userLat, userLng),
      LatLng(json['lat'], json['lon']),
    );

    return BarberShopModel(
      id: json['id'].toString(),
      lat: json['lat'],
      lng: json['lon'],
      name: json['tags']?['name'] ?? 'Unnamed Barber',
      address: json['tags']?['addr:street'] ?? '',
      distance: distance,
    );
  }
}

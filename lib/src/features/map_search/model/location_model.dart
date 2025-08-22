enum LocationType { atm, branch }

LocationType _typeFromString(String v) =>
    v.toUpperCase() == 'BRANCH' ? LocationType.branch : LocationType.atm;

String _typeToString(LocationType t) =>
    t == LocationType.branch ? 'Branch' : 'ATM';

class LocationModel {
  final int id;
  final LocationType type;
  final String name;
  final String address;
  final double lat;
  final double lng;

  LocationModel({
    required this.id,
    required this.type,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json['id'] as int,
    type: _typeFromString(json['type'] as String),
    name: json['name'] as String,
    address: json['address'] as String,
    lat: (json['location']['lat'] as num).toDouble(),
    lng: (json['location']['lng'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': _typeToString(type),
    'name': name,
    'address': address,
    'location': {'lat': lat, 'lng': lng},
  };
}

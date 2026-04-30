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
  final String phoneNumber;
  final bool branchService;
  final double lat;
  final double lng;
  final List<WorkingHoursModel>? workingHours;

  LocationModel({
    required this.id,
    required this.type,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.branchService,
    required this.lat,
    required this.lng,
    required this.workingHours,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

    type: _typeFromString(json['type']?.toString() ?? "ATM"),

    name: json['name']?.toString() ?? '',
    address: json['address']?.toString() ?? '',
    phoneNumber: json['phone_number']?.toString() ?? '',

    branchService: json['branch_services'] == true,

    lat: (json['location']?['lat'] as num?)?.toDouble() ?? 0,
    lng: (json['location']?['lng'] as num?)?.toDouble() ?? 0,

    workingHours: (json['working_hours'] as List<dynamic>?)
        ?.map((item) => WorkingHoursModel.fromJson(item))
        .toList(),
  );

}

class WorkingHoursModel {
  final String? day;
  final String? from;
  final String? to;

  WorkingHoursModel({this.day, this.from, this.to});

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
        day: json['day'],
        from: json['from'],
        to: json['to'],
    );
  }

}
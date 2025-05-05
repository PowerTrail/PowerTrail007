class SolarPlantModel {
  final String id;
  final String developer;
  final String location;
  final String districtId;
  final double acCapacity;
  final double dcCapacity;
  final String substation;
  final String? ehvSubstation;
  final DateTime? commissioningDate;
  final String? plantType;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  SolarPlantModel({
    required this.id,
    required this.developer,
    required this.location,
    required this.districtId,
    required this.acCapacity,
    required this.dcCapacity,
    required this.substation,
    this.ehvSubstation,
    this.commissioningDate,
    this.plantType,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  factory SolarPlantModel.fromJson(Map<String, dynamic> json) {
    return SolarPlantModel(
      id: json['id'],
      developer: json['developer'] ?? 'Unknown Developer',
      location: json['location'] ?? 'Unknown Location',
      districtId: json['district_id'] ?? 'Unknown District',
      acCapacity: json['ac_capacity'] != null 
          ? double.parse(json['ac_capacity'].toString()) 
          : 0.0,
      dcCapacity: json['dc_capacity'] != null 
          ? double.parse(json['dc_capacity'].toString()) 
          : 0.0,
      substation: json['substation'] ?? 'Unknown Substation',
      ehvSubstation: json['ehv_substation'],
      commissioningDate: json['commissioning_date'] != null 
          ? DateTime.parse(json['commissioning_date']) 
          : null,
      plantType: json['plant_type'],
      latitude: json['latitude'] != null 
          ? double.parse(json['latitude'].toString()) 
          : null,
      longitude: json['longitude'] != null 
          ? double.parse(json['longitude'].toString()) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'developer': developer,
      'location': location,
      'district_id': districtId,
      'ac_capacity': acCapacity,
      'dc_capacity': dcCapacity,
      'substation': substation,
      'ehv_substation': ehvSubstation,
      'commissioning_date': commissioningDate?.toIso8601String(),
      'plant_type': plantType,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

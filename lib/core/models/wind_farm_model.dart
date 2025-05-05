class WindFarmModel {
  final String id;
  final String owner;
  final String village;
  final String substation;
  final String districtId;
  final double? totalApprovedCapacity;
  final double? windCapacity;
  final double? solarCapacity;
  final DateTime? commissioningDate;
  final DateTime createdAt;

  WindFarmModel({
    required this.id,
    required this.owner,
    required this.village,
    required this.substation,
    required this.districtId,
    this.totalApprovedCapacity,
    this.windCapacity,
    this.solarCapacity,
    this.commissioningDate,
    required this.createdAt,
  });

  factory WindFarmModel.fromJson(Map<String, dynamic> json) {
    return WindFarmModel(
      id: json['id'],
      owner: json['owner'] ?? 'Unknown Owner',
      village: json['village'] ?? 'Unknown Village',
      substation: json['substation'] ?? 'Unknown Substation',
      districtId: json['district_id'] ?? 'Unknown District',
      totalApprovedCapacity: json['total_approved_capacity'] != null 
          ? double.parse(json['total_approved_capacity'].toString()) 
          : null,
      windCapacity: json['wind_capacity'] != null 
          ? double.parse(json['wind_capacity'].toString()) 
          : null,
      solarCapacity: json['solar_capacity'] != null 
          ? double.parse(json['solar_capacity'].toString()) 
          : null,
      commissioningDate: json['commissioning_date'] != null 
          ? DateTime.parse(json['commissioning_date']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'village': village,
      'substation': substation,
      'district_id': districtId,
      'total_approved_capacity': totalApprovedCapacity,
      'wind_capacity': windCapacity,
      'solar_capacity': solarCapacity,
      'commissioning_date': commissioningDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

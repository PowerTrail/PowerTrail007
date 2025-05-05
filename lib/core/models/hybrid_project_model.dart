class HybridProjectModel {
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

  HybridProjectModel({
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

  factory HybridProjectModel.fromJson(Map<String, dynamic> json) {
    return HybridProjectModel(
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
}
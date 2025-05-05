class SubstationModel {
  final String id;
  final String? name;
  final String? district;
  final String? voltageLevel;
  final double latitude;
  final double longitude;
  final String? discomId;
  final DateTime? commissioningDate;
  final double? transformerCapacity;
  final String type;
  final bool isOnline;
  final String? schema;
  final int? reliabilityPercentage;
  final DateTime? lastMaintenanceDate;
  final String? controlSystem;
  final DateTime lastUpdated;

  SubstationModel({
    required this.id,
    this.name,
    this.district,
    this.voltageLevel,
    required this.latitude,
    required this.longitude,
    this.discomId,
    this.commissioningDate,
    this.transformerCapacity,
    required this.type,
    required this.isOnline,
    this.schema,
    this.reliabilityPercentage,
    this.lastMaintenanceDate,
    this.controlSystem,
    required this.lastUpdated,
  });

  factory SubstationModel.fromJson(Map<String, dynamic> json) {
    return SubstationModel(
      id: json['id'] ?? '',
      name: json['name'],
      district: json['district_id'],
      voltageLevel: json['voltage_level'],
      latitude: json['latitude'] != null 
          ? double.tryParse(json['latitude'].toString()) ?? 0.0 
          : 0.0,
      longitude: json['longitude'] != null 
          ? double.tryParse(json['longitude'].toString()) ?? 0.0 
          : 0.0,
      discomId: json['discom_id'],
      commissioningDate: json['commissioning_date'] != null 
          ? DateTime.tryParse(json['commissioning_date'].toString())
          : null,
      transformerCapacity: json['transformer_capacity'] != null 
          ? double.tryParse(json['transformer_capacity'].toString())
          : null,
      type: json['type'] ?? 'Substation',
      isOnline: json['status'] == 'Online',
      schema: json['schema'],
      reliabilityPercentage: json['reliability_percentage'] != null
          ? int.tryParse(json['reliability_percentage'].toString())
          : null,
      lastMaintenanceDate: json['last_maintenance_date'] != null 
          ? DateTime.tryParse(json['last_maintenance_date'].toString())
          : null,
      controlSystem: json['control_system'],
      lastUpdated: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district_id': district,
      'voltage_level': voltageLevel,
      'latitude': latitude,
      'longitude': longitude,
      'discom_id': discomId,
      'commissioning_date': commissioningDate?.toIso8601String(),
      'transformer_capacity': transformerCapacity,
      'type': type,
      'status': isOnline ? 'Online' : 'Offline',
      'schema': schema,
      'reliability_percentage': reliabilityPercentage,
      'last_maintenance_date': lastMaintenanceDate?.toIso8601String(),
      'control_system': controlSystem,
      'updated_at': lastUpdated.toIso8601String(),
    };
  }
}
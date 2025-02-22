class Vehicle {
  final int? id;
  final String vehicleName;
  final String model;
  final String registrationNo;
  final String registrationDate;
  final double milageKmPerLiter;

  Vehicle({
    this.id,
    required this.vehicleName,
    required this.model,
    required this.registrationNo,
    required this.registrationDate,
    required this.milageKmPerLiter,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      vehicleName: json['vehicle_name'],
      model: json['model'],
      registrationNo: json['registration_no'],
      registrationDate: json['registration_date'],
      milageKmPerLiter: json['milage_km_per_liter'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_name': vehicleName,
      'model': model,
      'registration_no': registrationNo,
      'registration_date': registrationDate,
      'milage_km_per_liter': milageKmPerLiter,
    };
  }
}
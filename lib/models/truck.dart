class Truck {
  String truckId;
  String brand;
  String plateNumber;

  Truck({
    required this.truckId,
    required this.brand,
    required this.plateNumber,
  });

  // Add a factory constructor for JSON deserialization
  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      truckId: json['truckId'],
      brand: json['brand'],
      plateNumber: json['plateNumber'],
    );
  }

  // Add a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'truckId': truckId,
      'brand': brand,
      'plateNumber': plateNumber,
    };
  }
}

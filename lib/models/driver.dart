class Driver {
  String name;
  int age;
  String phoneNo;

  Driver({
    required this.name,
    required this.age,
    required this.phoneNo,
  });

  // Add a factory constructor for JSON deserialization
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'],
      age: json['age'],
      phoneNo: json['phoneNo'],
    );
  }

  // Add a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'phoneNo': phoneNo,
    };
  }
}

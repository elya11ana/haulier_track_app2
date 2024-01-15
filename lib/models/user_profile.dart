class UserProfile {
  String name;
  String email;
  String mobileNumber;
  String? imagePath;

  UserProfile({
    required this.name, 
    required this.email, 
    required this.mobileNumber,
    this.imagePath});

}
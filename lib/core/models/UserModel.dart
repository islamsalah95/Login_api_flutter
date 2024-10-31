class UserModel {
  final String name;
  final String email;
  final String phone;
  final List<dynamic> coordinates;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.coordinates,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'], // Access directly from 'data'
      email: json['email'],
      phone: json['phone'],
      coordinates: json['location'] != null ? json['location']['coordinates'] : [],
    );
  }
}

class SignUpModel {
  final String message;
  final Map<String, dynamic>? data;

  SignUpModel({required this.message, this.data});

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      message: json['message'],  // Assuming 'message' is at the top level
      data: json['data'] as Map<String, dynamic>?,  // Parse 'data' as a Map
    );
  }
}

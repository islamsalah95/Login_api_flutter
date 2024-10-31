import 'package:authentcation/core/api/Endpoints.dart';

class UpdateProfileModel {
  final String message;

  UpdateProfileModel({required this.message});

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      message: json['message'],
    );
  }
}





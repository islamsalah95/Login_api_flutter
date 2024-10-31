import 'package:authentcation/core/api/Endpoints.dart';

class SignInModel {
  final String token;

  SignInModel({ required this.token});

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      token: json['token'],
    );
  }
}




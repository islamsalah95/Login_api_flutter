import 'package:authentcation/core/errors/ErrorModel.dart';

class ServerExceptions implements Exception {

final ErrorModel errorModel;

 ServerExceptions({required this.errorModel});

}
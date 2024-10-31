import 'package:authentcation/core/api/Endpoints.dart';
import 'package:authentcation/core/database/CacheHelper.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor{

@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  // Set default headers
  options.headers['Accept-Language'] = 'en';
  options.headers['Accept'] = 'application/json';

  // Retrieve the token from CacheHelper
  final token = CacheHelper.getData(key: ApiKey.token);

  // Check if the token is not null and set the Authorization header accordingly
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  } else {
    // You might want to handle the case when there is no token
    options.headers.remove('Authorization'); // Remove the header if token is null
  }

  // Call the super method to proceed with the request
  super.onRequest(options, handler);
}



}
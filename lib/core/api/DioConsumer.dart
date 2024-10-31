import 'package:authentcation/core/api/ApiConsumer.dart';
import 'package:authentcation/core/api/ApiInterceptor.dart';
import 'package:authentcation/core/errors/ErrorModel.dart';
import 'package:authentcation/core/errors/ServerExceptions.dart';
import 'package:dio/dio.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = "https://lightsteelblue-rail-575879.hostingersite.com/api/v1/";
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
    dio.interceptors.add(ApiInterceptor());
  }

  Future<Response<dynamic>> handelRequest(
    String path,
    dynamic? data,
    Map<String, dynamic>? queryParamter,
    String requestType,
    bool isFormData,
  ) async {
    try {
      final response = await dio.request(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParamter,
        options: Options(method: requestType),
      );
      print(response.data.toString());
      return response;  // Return the response to the caller
    } on DioException catch (e) {
      final errorData = e.response?.data;
      print(errorData);
      if (errorData is Map<String, dynamic>) {
        throw ServerExceptions(errorModel: ErrorModel.fromJson(errorData));
      } else {
        throw ServerExceptions(
            errorModel: ErrorModel(
                statusCode: e.response?.statusCode ?? 0,
                message: 'An unknown error occurred'));
      }
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  @override
  Future<Response<dynamic>> delete(String path,
      {Object? data, Map<String, dynamic>? queryParamter, bool isFormData = false}) async {
    return await handelRequest(path, data, queryParamter, "DELETE", isFormData);
  }

  @override
  Future<Response<dynamic>> get(String path,
      {Object? data, Map<String, dynamic>? queryParamter, bool isFormData = false}) async {
    return await handelRequest(path, data, queryParamter, "GET", isFormData);
  }

  @override
  Future<Response<dynamic>> patch(String path,
      {Object? data, Map<String, dynamic>? queryParamter, bool isFormData = false}) async {
    return await handelRequest(path, data, queryParamter, "PATCH", isFormData);
  }

  @override
  Future<Response<dynamic>> post(String path,
      {Object? data, Map<String, dynamic>? queryParamter, bool isFormData = false}) async {
    return await handelRequest(path, data, queryParamter, 'POST', isFormData);
  }
}

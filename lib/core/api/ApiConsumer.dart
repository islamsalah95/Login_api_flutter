abstract class ApiConsumer {
  get(   String  path,{Object? data, Map<String, dynamic>? queryParamter,bool isFormData=false});
  post(  String  path,{Object? data, Map<String, dynamic>? queryParamter,bool isFormData=false});
  patch( String  path,{Object? data, Map<String, dynamic>? queryParamter,bool isFormData=false});
  delete(String  path,{Object? data, Map<String, dynamic>? queryParamter,bool isFormData=false});
}

class ErrorModel {
  final int statusCode;
  final String message;
  ErrorModel({required this.statusCode, required this.message});
  factory ErrorModel.fromJson(json){
    return ErrorModel(
        statusCode:json['status'] ,
        message:json['ErrorMessage']
      );
  }
  
}
class Endpoints{
  // static const String baseUrl="token";
  // static const String signUp="user/signup";
  // static const String signIn="user/signin";
  // static const String update="user/update";

//   static  String  getUserEndPint(String ? id){
//  return "user/get-user/$id";
//   }

  static const String baseUrl="token";
  static const String signUp="register";
  static const String signIn="signin";
  static const String update="profiles/update";


  static  String  getUserEndPint(String ? id){
 return "https://lightsteelblue-rail-575879.hostingersite.com/api/v1/profiles";
  }




}


class ApiKey{
  static const String token="token";
  static const String message="message";
  static const String id="id";
  static const String name="name";
  static const String email="email";
  static const String password="password";
  static const String confirmPassword="confirmPassword";
  static const String phone="phone";
  static const String location="location";
  static const String profilePic="profilePic";
  static const String coordinates="coordinates";
  static const String value="value";

}
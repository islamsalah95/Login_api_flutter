import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  // Initialize the SharedPreferences instance
  static initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save data method handling different data types
  static Future<bool> saveData({required String key, required dynamic value}) {
    if (value is String) {
      return sharedPreferences!.setString(key, value);
    } else if (value is int) {
      return sharedPreferences!.setInt(key, value);
    } else if (value is bool) {
      return sharedPreferences!.setBool(key, value);
    } else if (value is double) {
      return sharedPreferences!.setDouble(key, value);
    } else {
      throw Exception("Invalid data type");
    }
  }

  // Get data for a specific key
  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }


  // remove data method handling different data types
  static Future<bool> removeData({required String key})async{
     return await sharedPreferences!.remove(key);
  }

  // check key exist
  static Future<bool> containKey({required String key})async{
     return  sharedPreferences!.containsKey(key);
  }

  // remove all data
    static Future<bool> clearData()async{
     return await sharedPreferences!.clear();
  }
  
}

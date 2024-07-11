import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static String userRoomIdKey = "USERROOMIDKEY";
  static String userJoinedKey = "JOINEDKEY";

  // room id

  static Future<bool> saveUserJoinedStatus(bool isUserJoined) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userJoinedKey, isUserJoined);
  }

  static Future<bool?> getUserJoinedStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userJoinedKey);
  }

  static Future<bool> saveUserRoomIdSF(String userRoomID) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRoomIdKey, userRoomID);
  }

  static Future<String?> getUserRoomIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userRoomIdKey);
  }
}

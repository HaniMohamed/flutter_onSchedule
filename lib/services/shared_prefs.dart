import 'package:shared_preferences/shared_preferences.dart';

// ملف حفظ بيانات تسجيل الدخول
class SharedPrefs {

// استدعاء ايميل المستخدم
  Future<String> getSharedEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("email");
  }

// استدعاء إسم المستخدم
  Future<String> getSharedName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("name");
  }

// حفظ اسم وايميل المستخدم
  setSharedStringValue(key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
  }
}

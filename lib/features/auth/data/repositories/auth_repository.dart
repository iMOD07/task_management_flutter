import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task_management_app/core/utils/token_storage.dart'; // Import the storage file

class AuthRepository {
  Future<String?> registerUser(Map<String, dynamic> data) async {
    // تحديد الرابط حسب نوع المستخدم
    String userType = data["userType"];
    late String urlStr;
    if (userType == "Client") {
      urlStr = 'http://localhost:8080/api/auth/register/client';
    } else {
      urlStr = 'http://localhost:8080/api/auth/register/employee';
    }
    final url = Uri.parse(urlStr);

    // حذف userType لأنه غير مطلوب في الباكند
    data.remove("userType");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];
        await saveToken(token);
        return response.body; // نجاح
      } else {
        return "فشل التسجيل: ${response.body}";
      }
    } catch (e) {
      return "خطأ في الاتصال: $e";
    }
  }
}

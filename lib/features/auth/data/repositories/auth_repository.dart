import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
    String userType = data["userType"];
    late String urlStr;
    if (userType == "Client") {
      urlStr = 'http://localhost:8080/api/auth/register/client';
    } else if (userType == "Employee") {
      urlStr = 'http://localhost:8080/api/auth/register/employee';
    }
    final url = Uri.parse(urlStr);

    data.remove("userType");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // إذا فيه توكن اعتبر التسجيل ناجح
        if (responseData['token'] != null) {
          return {"success": true, "data": responseData};
        } else {
          return {"success": false, "message": response.body.toString()};
        }
      } else {
        return {"success": false, "message": response.body.toString()};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task_management_app/core/utils/token_storage.dart';

Future<List<dynamic>> fetchTasks() async {
  String? token = await getToken();
  final url = Uri.parse('http://10.0.2.2:8080/api/tasks'); // Change the API according to your server

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('فشل جلب المهام: ${response.body}');
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ExpatrioApiService {
  static const String baseUrl = 'https://dev-api.expatrio.com';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/auth/login');

    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      // TODO improve error case
      throw Exception('Failed to login');
    }
  }
}

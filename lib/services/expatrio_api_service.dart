import 'dart:convert';
import 'package:expatrio_coding_challenge/models/account_info.dart';
import 'package:http/http.dart' as http;

class ExpatrioApiService {
  static const String baseUrl = 'https://dev-api.expatrio.com';

  Future<AccountInfo> login(String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/auth/login');

    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> subject = responseData['subject'];
        return AccountInfo.fromJson(subject);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage =
            errorData['message'] ?? 'Failed to login (${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}

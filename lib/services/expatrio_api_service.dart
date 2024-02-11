import 'dart:convert';

import 'package:expatrio_coding_challenge/models/user_tax_data.dart';
import 'package:http/http.dart' as http;

class ExpatrioApiService {
  static const String baseUrl = 'https://dev-api.expatrio.com';

  Future<Map<String, dynamic>> login(String email, String password) async {
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
        final String accessToken = responseData['accessToken'];
        final int userId = responseData['subject']['userId'];
        return {'userId': userId, 'accessToken': accessToken};
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

  Future<UserTaxData> getUserTaxData(
    int userId,
    String accessToken,
  ) async {
    final Uri url = Uri.parse('$baseUrl/v3/customers/$userId/tax-data');

    try {
      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserTaxData.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['message'] ??
            'Failed to fetch tax data (${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to fetch tax data: $e');
    }
  }
}

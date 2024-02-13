import 'dart:convert';

import 'package:expatrio_coding_challenge/models/user_tax_data.dart';
import 'package:http/http.dart' as http;

class ExpatrioApiService {
  static const String _baseUrl = 'https://dev-api.expatrio.com';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');

    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final http.Response response = await postRequest(url, body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String accessToken = responseData['accessToken'];
        final int userId = responseData['subject']['userId'];
        return {'userId': userId, 'accessToken': accessToken};
      } else {
        handleError(response);
      }
    } catch (e) {
      _handleException(e);
    }

    throw Exception('Unexpected error occurred during login');
  }

  Future<UserTaxData> getUserTaxData({
    required int userId,
    required String accessToken,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/v3/customers/$userId/tax-data');

    try {
      final http.Response response = await getRequest(url, accessToken);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserTaxData.fromJson(responseData);
      } else {
        handleError(response);
      }
    } catch (e) {
      _handleException(e);
    }

    throw Exception('Unexpected error occurred while fetching user tax data');
  }

  Future<void> updateTaxData({
    required int userId,
    required String accessToken,
    required UserTaxData updatedTaxData,
  }) async {
    final Uri url = Uri.parse('$_baseUrl/v3/customers/$userId/tax-data');

    try {
      final http.Response response = await putRequest(
        url,
        accessToken,
        jsonEncode(updatedTaxData.toJson()),
      );

      if (response.statusCode != 200) {
        handleError(response);
      }
    } catch (e) {
      _handleException(e);
    }
  }

  Future<http.Response> postRequest(Uri url, Map<String, String> body) async {
    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  Future<http.Response> putRequest(
      Uri url, String accessToken, String body) async {
    return await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );
  }

  void handleError(http.Response response) {
    final Map<String, dynamic> errorData = jsonDecode(response.body);
    final String errorMessage =
        errorData['message'] ?? 'Failed (${response.statusCode})';
    throw Exception(errorMessage);
  }

  void _handleException(dynamic e) {
    throw Exception('Failed: $e');
  }
}

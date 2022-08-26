import 'dart:convert';
import 'package:http/http.dart' as http;

/// HttpWrapper
class HttpWrapper {
  ///
  HttpWrapper({required http.Client httpClient}) : _httpClient = httpClient;
  final http.Client _httpClient;

  /// POST method
  Future<Map<String, dynamic>> get(
    Uri uri, {
    Map<String, String>? header,
  }) async {
    final res = await _httpClient.get(uri, headers: header);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body;
    } else {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final message = body['message'] as String;
      throw Exception(message);
    }
  }

  /// POST method
  Future<Map<String, dynamic>> post(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    final res =
        await _httpClient.post(uri, body: jsonEncode(body), headers: header);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body;
    } else {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final message = body['message'] as String;
      throw Exception(message);
    }
  }

  /// PUT method
  Future<Map<String, dynamic>> put(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    final res =
        await _httpClient.put(uri, body: jsonEncode(body), headers: header);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body;
    } else {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final message = body['message'] as String;
      throw Exception(message);
    }
  }

  /// DELETE method
  Future<Map<String, dynamic>> delete(
    Uri uri, {
    Map<String, String>? header,
  }) async {
    final res = await _httpClient.delete(uri, headers: header);
    if (res.statusCode == 200) {
      return {};
    } else {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final message = body['message'] as String;
      throw Exception(message);
    }
  }
}

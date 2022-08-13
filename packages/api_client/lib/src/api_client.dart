// ignore_for_file: non_constant_identifier_names
import 'package:api_client/src/http_wrapper.dart';
import 'package:http/http.dart' as http;

/// {@template api_client}
/// The API client
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({required this.API_URL, required http.Client httpClient})
      : httpWrapper = HttpWrapper(httpClient: httpClient);

  /// The url of api
  final String API_URL;

  /// HttpWrapper instance
  final HttpWrapper httpWrapper;

  /// login into domain with email and password
  /// return auth-token if success
  Future<String> login(String domain, String email, String password) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'api/tenants/login'),
      body: {
        'domain': domain,
        'email': email,
        'password': password,
      },
    );
    final token = res['token'] as String;
    return token;
  }

  /// check if token is valid
  Future<Map<String, dynamic>> checkToken(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'api/tenants/account'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
}

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
      Uri.http(API_URL, 'v1/domain/login'),
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
      Uri.http(API_URL, 'v1/domain/account'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  // < PROJECT REST API>
  /// POST: create project
  Future<Map<String, dynamic>> createProject({
    required String token,
    required Map<String, dynamic> project,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/projects'),
      body: project,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get projects list
  Future<List<dynamic>> getProjects(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/projects'),
      header: {'Authorization': 'Bearer $token'},
    );
    final projects = res['projects'] as List<dynamic>;
    return projects;
  }

  /// GET: get project by ID
  Future<Map<String, dynamic>> getProject({
    required String token,
    required String projectID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/projects/$projectID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update project by ID
  Future<Map<String, dynamic>> updateProject({
    required String token,
    required String projectID,
    required Map<String, dynamic> project,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/projects/$projectID'),
      body: project,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete project by ID
  Future<Map<String, dynamic>> deleteProject({
    required String token,
    required String projectID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/projects/$projectID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // </ PROJECT REST API>

  // < GROUP REST API>
  /// POST: create group
  Future<Map<String, dynamic>> createGroup({
    required String token,
    required Map<String, dynamic> group,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/groups'),
      body: group,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get groups list
  Future<List<dynamic>> getGroups(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/groups'),
      header: {'Authorization': 'Bearer $token'},
    );
    final projects = res['groups'] as List<dynamic>;
    return projects;
  }

  /// GET: get group by ID
  Future<Map<String, dynamic>> getGroup({
    required String token,
    required String groupID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/groups/$groupID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update group by ID
  Future<Map<String, dynamic>> updateGroup({
    required String token,
    required String groupID,
    required Map<String, dynamic> group,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/groups/$groupID'),
      body: group,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete group by ID
  Future<Map<String, dynamic>> deleteGroup({
    required String token,
    required String groupID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/groups/$groupID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // </ GROUP REST API>

  // < DEVICE REST API>
  /// POST: create device
  Future<Map<String, dynamic>> createDevice({
    required String token,
    required Map<String, dynamic> device,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/devices'),
      body: device,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get devices list
  Future<List<dynamic>> getDevices(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/devices'),
      header: {'Authorization': 'Bearer $token'},
    );
    final projects = res['devices'] as List<dynamic>;
    return projects;
  }

  /// GET: get device by ID
  Future<Map<String, dynamic>> getDevice({
    required String token,
    required String deviceID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/devices/$deviceID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update device by ID
  Future<Map<String, dynamic>> updateDevice({
    required String token,
    required String deviceID,
    required Map<String, dynamic> device,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/devices/$deviceID'),
      body: device,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete device by ID
  Future<Map<String, dynamic>> deleteDevice({
    required String token,
    required String deviceID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/devices/$deviceID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // </ GROUP REST API>
}

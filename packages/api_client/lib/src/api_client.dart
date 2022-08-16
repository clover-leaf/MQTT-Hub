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
  Future<String> login(String domain, String username, String password) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/login'),
      body: {
        'domain': domain,
        'username': username,
        'password': password,
      },
    );
    final token = res['token'] as String;
    return token;
  }

  /// get user info match with JWT
  Future<Map<String, dynamic>> getUserInJWT(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/user'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  // ================== PROJECT REST API ========================
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
  // ================== PROJECT REST API ========================

  // ================== USER REST API ========================
  /// POST: create user
  Future<Map<String, dynamic>> createUser({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/users'),
      body: user,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get users list
  Future<List<dynamic>> getUsers(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/users'),
      header: {'Authorization': 'Bearer $token'},
    );
    final users = res['users'] as List<dynamic>;
    return users;
  }

  /// GET: get user by ID
  Future<Map<String, dynamic>> getUser({
    required String token,
    required String userID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/users/$userID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update user by ID
  Future<Map<String, dynamic>> updateUser({
    required String token,
    required String userID,
    required Map<String, dynamic> user,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/users/$userID'),
      body: user,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete user by ID
  Future<Map<String, dynamic>> deleteUser({
    required String token,
    required String userID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/users/$userID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // ================== USER REST API ========================

  // ================== USER-PROJECT REST API ========================
  /// POST: add user to project
  Future<Map<String, dynamic>> createUserProject({
    required String token,
    required Map<String, dynamic> userProject,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/users-projects'),
      body: userProject,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get user-project list
  Future<List<dynamic>> getUserProjects(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/users-projects'),
      header: {'Authorization': 'Bearer $token'},
    );
    final userProjects = res['users-projects'] as List<dynamic>;
    return userProjects;
  }

  /// GET: get user-project by ID
  Future<Map<String, dynamic>> getUserProject({
    required String token,
    required String id,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/users-projects/$id'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update user-project by ID
  Future<Map<String, dynamic>> updateUserProject({
    required String token,
    required String id,
    required Map<String, dynamic> userProject,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/users-projects/$id'),
      body: userProject,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete user-project by ID
  Future<Map<String, dynamic>> deleteUserProject({
    required String token,
    required String id,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/users-projects/$id'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // ================== USER-PROJECT REST API ========================

  // ================== BROKER REST API ========================
  /// POST: create broker
  Future<Map<String, dynamic>> createBroker({
    required String token,
    required Map<String, dynamic> broker,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/brokers'),
      body: broker,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get brokers list
  Future<List<dynamic>> getBrokers(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/brokers'),
      header: {'Authorization': 'Bearer $token'},
    );
    final brokers = res['brokers'] as List<dynamic>;
    return brokers;
  }

  /// GET: get broker by ID
  Future<Map<String, dynamic>> getBroker({
    required String token,
    required String brokerID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/brokers/$brokerID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update broker by ID
  Future<Map<String, dynamic>> updateBroker({
    required String token,
    required String brokerID,
    required Map<String, dynamic> broker,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/brokers/$brokerID'),
      body: broker,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete broker by ID
  Future<Map<String, dynamic>> deleteBroker({
    required String token,
    required String brokerID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/brokers/$brokerID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // ================== BROKER REST API ========================

  // ================== GROUP REST API ========================
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
  // ================== GROUP REST API ========================

  // ================== DEVICE REST API ========================
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
  // ================== DEVICE REST API ========================

  // ================== ATTRIBUTE REST API ========================
  /// POST: create attribute
  Future<Map<String, dynamic>> createAttribute({
    required String token,
    required Map<String, dynamic> attribute,
  }) async {
    final res = await httpWrapper.post(
      Uri.http(API_URL, 'v1/domain/attributes'),
      body: attribute,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// GET: get attributes list
  Future<List<dynamic>> getAttributes(String token) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/attributes'),
      header: {'Authorization': 'Bearer $token'},
    );
    final projects = res['attributes'] as List<dynamic>;
    return projects;
  }

  /// GET: get attribute by ID
  Future<Map<String, dynamic>> getAttribute({
    required String token,
    required String attributeID,
  }) async {
    final res = await httpWrapper.get(
      Uri.http(API_URL, 'v1/domain/attributes/$attributeID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// PUT: update attribute by ID
  Future<Map<String, dynamic>> updateAttribute({
    required String token,
    required String attributeID,
    required Map<String, dynamic> attribute,
  }) async {
    final res = await httpWrapper.put(
      Uri.http(API_URL, 'v1/domain/attributes/$attributeID'),
      body: attribute,
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  /// DELETE: delete attribute by ID
  Future<Map<String, dynamic>> deleteAttribute({
    required String token,
    required String attributeID,
  }) async {
    final res = await httpWrapper.delete(
      Uri.http(API_URL, 'v1/domain/attributes/$attributeID'),
      header: {'Authorization': 'Bearer $token'},
    );
    return res;
  }
  // ================== DEVICE REST API ========================
}

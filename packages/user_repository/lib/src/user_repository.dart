import 'package:api_client/api_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:secure_storage_client/secure_storage_client.dart';
import 'package:user_repository/user_repository.dart';

/// {@template user_repository}
/// A repository contain all client helper
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required ApiClient apiClient,
    required SecureStorageClient secureStorageClient,
    required String tokenKey,
  })  : _apiClient = apiClient,
        _secureStorageClient = secureStorageClient,
        _tokenKey = tokenKey;

  /// ApiClient
  final ApiClient _apiClient;

  /// SecureStorageClient
  final SecureStorageClient _secureStorageClient;

  /// JWT
  String? _token;

  /// JWT key
  final String _tokenKey;

  /// the controller of [Stream] of [Project]
  final _projectStreamController = BehaviorSubject<List<Project>>.seeded([]);

  /// the controller of [Stream] of [Group]
  final _groupStreamController = BehaviorSubject<List<Group>>.seeded([]);

  /// the controller of [Stream] of [Device]
  final _deviceStreamController = BehaviorSubject<List<Device>>.seeded([]);

  /// read secure-storage if it contains token
  Future<String> recoverSession() async {
    final token = await _secureStorageClient.readSecureData(_tokenKey);
    if (token != null) {
      return token;
    } else {
      throw Exception('Token not found');
    }
  }

  /// check if token is valid
  Future<void> checkToken(String token) async {
    await _apiClient.checkToken(token);
  }

  /// read all pair
  Future<Map<String, String>> readAll() async {
    return _secureStorageClient.readAll();
  }

  /// login into tenant with given data
  /// return token
  /// throw Exception(message) when fail
  Future<String> login(String domain, String email, String password) async {
    return _apiClient.login(domain, email, password);
  }

  /// set token
  Future<void> setToken(String token, {bool toWrite = true}) async {
    if (toWrite) {
      await _secureStorageClient.writeSecureData(_tokenKey, token);
    }
    _token = token;
  }

  /// reset token
  Future<void> resetToken() async {
    await _secureStorageClient.deleteSecureData(_tokenKey);
    _token = null;
  }

  // < PROJECT REST API>
  /// udate authenticator stream
  Stream<List<Project>> subscribeProjectStream() {
    return _projectStreamController.asBroadcastStream();
  }

  /// create or update project
  Future<void> saveProject(Project project) async {
    if (_token == null) throw Exception('Token not found');
    final projects = [..._projectStreamController.value];
    final idx = projects.indexWhere((t) => t.id == project.id);
    if (idx == -1) {
      await _apiClient.createProject(token: _token!, project: project.toJson());
      projects.add(project);
    } else {
      await _apiClient.updateProject(
        token: _token!,
        projectID: project.id,
        project: project.toJson(),
      );
      projects
        ..removeAt(idx)
        ..insertAll(idx, [project]);
    }
    _projectStreamController.add(projects);
  }

  /// get projects list
  Future<void> getProjects() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getProjects(_token!);
    final projects = data
        .map((dynamic json) => Project.fromJson(json as Map<String, dynamic>))
        .toList();
    _projectStreamController.add(projects);
  }

  /// delete project by ID
  Future<void> deleteProject(String projectID) async {
    if (_token == null) throw Exception('Token not found');
    final projects = [..._projectStreamController.value];
    final idx = projects.indexWhere((t) => t.id == projectID);
    if (idx > -1) {
      await _apiClient.deleteProject(token: _token!, projectID: projectID);
      projects.removeAt(idx);
      // update groups and device as well
      await getGroups();
      await getDevices();
      _projectStreamController.add(projects);
    }
  }
  // </ PROJECT REST API>

  // < GROUP REST API>
  /// udate authenticator stream
  Stream<List<Group>> subscribeGroupStream() {
    return _groupStreamController.asBroadcastStream();
  }

  /// create or update group
  Future<void> saveGroup(Group group) async {
    if (_token == null) throw Exception('Token not found');
    final groups = [..._groupStreamController.value];
    final idx = groups.indexWhere((t) => t.id == group.id);
    if (idx == -1) {
      await _apiClient.createGroup(token: _token!, group: group.toJson());
      groups.add(group);
    } else {
      await _apiClient.updateGroup(
        token: _token!,
        groupID: group.id,
        group: group.toJson(),
      );
      groups
        ..removeAt(idx)
        ..insertAll(idx, [group]);
    }
    _groupStreamController.add(groups);
  }

  /// get group list
  Future<void> getGroups() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getGroups(_token!);
    final groups = data
        .map((dynamic json) => Group.fromJson(json as Map<String, dynamic>))
        .toList();
    _groupStreamController.add(groups);
  }

  /// delete group by ID
  Future<void> deleteGroup(String groupID) async {
    final groups = [..._groupStreamController.value];
    final idx = groups.indexWhere((t) => t.id == groupID);
    if (idx > -1) {
      await _apiClient.deleteGroup(token: _token!, groupID: groupID);
      // update groups and device as well
      await getGroups();
      await getDevices();
    }
  }
  // </ GROUP REST API>

  // < DEVICE REST API>
  /// udate authenticator stream
  Stream<List<Device>> subscribeDeviceStream() {
    return _deviceStreamController.asBroadcastStream();
  }

  /// create or update device
  Future<void> saveDevice(Device device) async {
    if (_token == null) throw Exception('Token not found');
    final devices = [..._deviceStreamController.value];
    final idx = devices.indexWhere((t) => t.id == device.id);
    if (idx == -1) {
      await _apiClient.createDevice(token: _token!, device: device.toJson());
      devices.add(device);
    } else {
      await _apiClient.updateDevice(
        token: _token!,
        deviceID: device.id,
        device: device.toJson(),
      );
      devices
        ..removeAt(idx)
        ..insertAll(idx, [device]);
    }
    _deviceStreamController.add(devices);
  }

  /// get device list
  Future<void> getDevices() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getDevices(_token!);
    final devices = data
        .map((dynamic json) => Device.fromJson(json as Map<String, dynamic>))
        .toList();
    _deviceStreamController.add(devices);
  }

  /// delete device by ID
  Future<void> deleteDevice(String deviceID) async {
    final devices = [..._deviceStreamController.value];
    final idx = devices.indexWhere((t) => t.id == deviceID);
    if (idx > -1) {
      await _apiClient.deleteDevice(token: _token!, deviceID: deviceID);
      devices.removeAt(idx);
      _deviceStreamController.add(devices);
    }
  }
  // </ DEVICE REST API>
}

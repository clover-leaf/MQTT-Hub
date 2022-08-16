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

  /// the controller of [Stream] of [Broker]
  final _brokerStreamController = BehaviorSubject<List<Broker>>.seeded([]);

  /// the controller of [Stream] of [User]
  final _userStreamController = BehaviorSubject<List<User>>.seeded([]);

  /// the controller of [Stream] of [UserProject]
  final _userProjectStreamController =
      BehaviorSubject<List<UserProject>>.seeded([]);

  /// the controller of [Stream] of [Group]
  final _groupStreamController = BehaviorSubject<List<Group>>.seeded([]);

  /// the controller of [Stream] of [Device]
  final _deviceStreamController = BehaviorSubject<List<Device>>.seeded([]);

  /// the controller of [Stream] of [Attribute]
  final _attributeStreamController =
      BehaviorSubject<List<Attribute>>.seeded([]);

  /// read secure-storage if it contains token
  Future<String> recoverSession() async {
    final token = await _secureStorageClient.readSecureData(_tokenKey);
    if (token != null) {
      return token;
    } else {
      throw Exception('Token not found');
    }
  }

  /// get user info match with JWT
  Future<void> getUserInJWT(String token) async {
    await _apiClient.getUserInJWT(token);
  }

  /// read all pair
  Future<Map<String, String>> readAll() async {
    return _secureStorageClient.readAll();
  }

  /// login into tenant with given data
  /// return token
  /// throw Exception(message) when fail
  Future<String> login(String domain, String username, String password) async {
    return _apiClient.login(domain, username, password);
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

  // ================== PROJECT REST API ========================
  ///
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
  // ================== PROJECT REST API ========================

  // ================== USER REST API ========================
  ///
  Stream<List<User>> subscribeUserStream() {
    return _userStreamController.asBroadcastStream();
  }

  /// create or update user
  Future<void> saveUser(User user) async {
    if (_token == null) throw Exception('Token not found');
    final users = [..._userStreamController.value];
    final idx = users.indexWhere((t) => t.id == user.id);
    if (idx == -1) {
      await _apiClient.createUser(token: _token!, user: user.toJson());
      users.add(user);
    } else {
      await _apiClient.updateUser(
        token: _token!,
        userID: user.id,
        user: user.toJson(),
      );
      users
        ..removeAt(idx)
        ..insertAll(idx, [user]);
    }
    _userStreamController.add(users);
  }

  /// get user list
  Future<void> getUsers() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getUsers(_token!);
    final users = data
        .map((dynamic json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
    _userStreamController.add(users);
  }

  /// delete user by ID
  Future<void> deleteUser(String userID) async {
    final users = [..._userStreamController.value];
    final idx = users.indexWhere((t) => t.id == userID);
    if (idx > -1) {
      await _apiClient.deleteUser(token: _token!, userID: userID);
      users.removeAt(idx);
      _userStreamController.add(users);
    }
  }
  // ================== USER REST API ========================

  // ================== USER-PROJECT REST API ========================
  ///
  Stream<List<UserProject>> subscribeUserProjectStream() {
    return _userProjectStreamController.asBroadcastStream();
  }

  /// create or update user-project
  Future<void> saveUserProject(UserProject userProject) async {
    if (_token == null) throw Exception('Token not found');
    final userProjects = [..._userProjectStreamController.value];
    final idx = userProjects.indexWhere((t) => t.id == userProject.id);
    if (idx == -1) {
      await _apiClient.createUserProject(
        token: _token!,
        userProject: userProject.toJson(),
      );
      userProjects.add(userProject);
    } else {
      await _apiClient.updateUserProject(
        token: _token!,
        id: userProject.id,
        userProject: userProject.toJson(),
      );
      userProjects
        ..removeAt(idx)
        ..insertAll(idx, [userProject]);
    }
    _userProjectStreamController.add(userProjects);
  }

  /// get user-project list
  Future<void> getUserProjects() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getUserProjects(_token!);
    final userProjects = data
        .map(
          (dynamic json) => UserProject.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    _userProjectStreamController.add(userProjects);
  }

  /// delete user-project by ID
  Future<void> deleteUserProject(String id) async {
    final userProjects = [..._userProjectStreamController.value];
    final idx = userProjects.indexWhere((t) => t.id == id);
    if (idx > -1) {
      await _apiClient.deleteUserProject(token: _token!, id: id);
      userProjects.removeAt(idx);
      _userProjectStreamController.add(userProjects);
    }
  }
  // ================== USER-PROJECT REST API ========================

  // ================== BROKER REST API ========================
  ///
  Stream<List<Broker>> subscribeBrokerStream() {
    return _brokerStreamController.asBroadcastStream();
  }

  /// create or update broker
  Future<void> saveBroker(Broker broker) async {
    if (_token == null) throw Exception('Token not found');
    final brokers = [..._brokerStreamController.value];
    final idx = brokers.indexWhere((t) => t.id == broker.id);
    if (idx == -1) {
      await _apiClient.createBroker(token: _token!, broker: broker.toJson());
      brokers.add(broker);
    } else {
      await _apiClient.updateBroker(
        token: _token!,
        brokerID: broker.id,
        broker: broker.toJson(),
      );
      brokers
        ..removeAt(idx)
        ..insertAll(idx, [broker]);
    }
    _brokerStreamController.add(brokers);
  }

  /// get broker list
  Future<void> getBrokers() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getBrokers(_token!);
    final brokers = data
        .map((dynamic json) => Broker.fromJson(json as Map<String, dynamic>))
        .toList();
    _brokerStreamController.add(brokers);
  }

  /// delete broker by ID
  Future<void> deleteBroker(String brokerID) async {
    final brokers = [..._brokerStreamController.value];
    final idx = brokers.indexWhere((t) => t.id == brokerID);
    if (idx > -1) {
      await _apiClient.deleteBroker(token: _token!, brokerID: brokerID);
      brokers.removeAt(idx);
      _brokerStreamController.add(brokers);
    }
  }
  // ================== BROKER REST API ========================

  // ================== GROUP REST API ========================
  ///
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
  // ================== GROUP REST API ========================

  // ================== DEVICE REST API ========================
  ///
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
  // ================== DEVICE REST API ========================

  // ================== ATTRIBUTE REST API ========================
  ///
  Stream<List<Attribute>> subscribeAttributeStream() {
    return _attributeStreamController.asBroadcastStream();
  }

  /// create or update attribute
  Future<void> saveAttribute(Attribute attribute) async {
    if (_token == null) throw Exception('Token not found');
    final attributes = [..._attributeStreamController.value];
    final idx = attributes.indexWhere((t) => t.id == attribute.id);
    if (idx == -1) {
      await _apiClient.createAttribute(
        token: _token!,
        attribute: attribute.toJson(),
      );
      attributes.add(attribute);
    } else {
      await _apiClient.updateAttribute(
        token: _token!,
        attributeID: attribute.id,
        attribute: attribute.toJson(),
      );
      attributes
        ..removeAt(idx)
        ..insertAll(idx, [attribute]);
    }
    _attributeStreamController.add(attributes);
  }

  /// get attribute list
  Future<void> getAttributes() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getAttributes(_token!);
    final attributes = data
        .map((dynamic json) => Attribute.fromJson(json as Map<String, dynamic>))
        .toList();
    _attributeStreamController.add(attributes);
  }

  /// delete attribute by ID
  Future<void> deleteAttribute(String attributeID) async {
    final attributes = [..._attributeStreamController.value];
    final idx = attributes.indexWhere((t) => t.id == attributeID);
    if (idx > -1) {
      await _apiClient.deleteAttribute(
        token: _token!,
        attributeID: attributeID,
      );
      attributes.removeAt(idx);
      _attributeStreamController.add(attributes);
    }
  }
  // ================== ATTRIBUTE REST API ========================
}

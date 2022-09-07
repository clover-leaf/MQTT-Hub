import 'package:api_client/api_client.dart';
import 'package:gateway_client/gateway_client.dart';
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

  // ================== GATEWAY ======================

  /// Creates [GatewayClient]
  GatewayClient createClient({
    required String brokerID,
    required String url,
    required int port,
    required String? account,
    required String? password,
  }) {
    return GatewayClient(
      brokerID: brokerID,
      url: url,
      port: port,
      account: account,
      password: password,
    );
  }

  /// Gets a [Stream] of published msg from given [GatewayClient]
  Stream<Map<String, String>> getPublishMessage(GatewayClient client) {
    return client.getPublishMessage();
  }

  /// Publish payload given [GatewayClient]
  void publishMessage(
    GatewayClient client, {
    required String payload,
    required String topic,
    required int qos,
    bool retain = true,
  }) {
    client.published(payload: payload, topic: topic, retain: retain, qos: qos);
  }

  /// Gets a [Stream] of [ConnectionStatus] from given [GatewayClient]
  Stream<ConnectionStatus> getConnectionStatus(GatewayClient client) {
    return client.getConnectionStatus();
  }

  /// Close connection status stream
  Future<void> closeConnectionStatusStream(GatewayClient client) async =>
      client.closeConnectionStatusStream();

  // ================== API ======================
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

  /// the controller of [Stream] of [DeviceType]
  final _deviceTypeStreamController =
      BehaviorSubject<List<DeviceType>>.seeded([]);

  /// the controller of [Stream] of [Attribute]
  final _attributeStreamController =
      BehaviorSubject<List<Attribute>>.seeded([]);

  /// the controller of [Stream] of [Dashboard]
  final _dashboardStreamController =
      BehaviorSubject<List<Dashboard>>.seeded([]);

  /// the controller of [Stream] of [Tile]
  final _tileStreamController = BehaviorSubject<List<Tile>>.seeded([]);

  /// the controller of [Stream] of [Alert]
  final _alertStreamController = BehaviorSubject<List<Alert>>.seeded([]);

  /// the controller of [Stream] of [Condition]
  final _conditionStreamController =
      BehaviorSubject<List<Condition>>.seeded([]);

  /// the controller of [Stream] of [TAction]
  final _actionStreamController = BehaviorSubject<List<TAction>>.seeded([]);

  /// the controller of [Stream] of [Log]
  final _logStreamController = BehaviorSubject<List<Log>>.seeded([]);

  /// the controller of [Stream] of [ConditionLog]
  final _conditionLogStreamController =
      BehaviorSubject<List<ConditionLog>>.seeded([]);

  /// the controller of [Stream] of [ActionTile]
  final _actionTileStreamController =
      BehaviorSubject<List<ActionTile>>.seeded([]);

  /// the controller of [Stream] of [Schedule]
  final _scheduleStreamController = BehaviorSubject<List<Schedule>>.seeded([]);

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
  Future<Map<String, dynamic>> getUserInJWT(String token) async {
    return _apiClient.getUserInJWT(token);
  }

  /// read all pair
  Future<Map<String, String>> readAll() async {
    return _secureStorageClient.readAll();
  }

  /// login into tenant with given data
  /// return token
  /// throw Exception(message) when fail
  Future<Map<String, dynamic>> login(
    String domain,
    String username,
    String password,
  ) async {
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

  /// reset stream
  void resetStream() {
    _projectStreamController.add([]);
    _brokerStreamController.add([]);
    _groupStreamController.add([]);
    _deviceStreamController.add([]);
    _deviceTypeStreamController.add([]);
    _attributeStreamController.add([]);
    _dashboardStreamController.add([]);
    _tileStreamController.add([]);
    _userStreamController.add([]);
    _userProjectStreamController.add([]);
    _alertStreamController.add([]);
    _conditionStreamController.add([]);
    _actionStreamController.add([]);
    _logStreamController.add([]);
    _actionTileStreamController.add([]);
    _scheduleStreamController.add([]);
  }

  /// get initial data for both admin and user
  Future<void> initialize() async {
    if (_token == null) throw Exception('Token not found');
    final res = await _apiClient.getInitialData(_token!);
    // decode value
    final projectJsons = res['projects'] as List<dynamic>;
    final projects = projectJsons
        .map((dynamic json) => Project.fromJson(json as Map<String, dynamic>))
        .toList();
    final brokerJsons = res['brokers'] as List<dynamic>;
    final brokers = brokerJsons
        .map((dynamic json) => Broker.fromJson(json as Map<String, dynamic>))
        .toList();
    final groupJsons = res['groups'] as List<dynamic>;
    final groups = groupJsons
        .map((dynamic json) => Group.fromJson(json as Map<String, dynamic>))
        .toList();
    final deviceJsons = res['devices'] as List<dynamic>;
    final devices = deviceJsons
        .map((dynamic json) => Device.fromJson(json as Map<String, dynamic>))
        .toList();
    final deviceTypeJsons = res['device-types'] as List<dynamic>;
    final deviceTypes = deviceTypeJsons
        .map(
          (dynamic json) => DeviceType.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    final attributeJsons = res['attributes'] as List<dynamic>;
    final attributes = attributeJsons
        .map((dynamic json) => Attribute.fromJson(json as Map<String, dynamic>))
        .toList();
    final dashboardJsons = res['dashboards'] as List<dynamic>;
    final dashboards = dashboardJsons
        .map((dynamic json) => Dashboard.fromJson(json as Map<String, dynamic>))
        .toList();
    final tileJsons = res['tiles'] as List<dynamic>;
    final tiles = tileJsons
        .map((dynamic json) => Tile.fromJson(json as Map<String, dynamic>))
        .toList();
    final alertJsons = res['alerts'] as List<dynamic>;
    final alerts = alertJsons
        .map((dynamic json) => Alert.fromJson(json as Map<String, dynamic>))
        .toList();
    final conditionJsons = res['conditions'] as List<dynamic>;
    final conditions = conditionJsons
        .map((dynamic json) => Condition.fromJson(json as Map<String, dynamic>))
        .toList();
    final actionJsons = res['actions'] as List<dynamic>;
    final actions = actionJsons
        .map((dynamic json) => TAction.fromJson(json as Map<String, dynamic>))
        .toList();
    final logJsons = res['logs'] as List<dynamic>;
    final logs = logJsons
        .map((dynamic json) => Log.fromJson(json as Map<String, dynamic>))
        .toList();
    final conditionLogJsons = res['condition-logs'] as List<dynamic>;
    final conditionLogs = conditionLogJsons
        .map(
          (dynamic json) => ConditionLog.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    final actionTileJsons = res['action-tiles'] as List<dynamic>;
    final actionTiles = actionTileJsons
        .map(
          (dynamic json) => ActionTile.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    final scheduleJsons = res['schedules'] as List<dynamic>;
    final schedules = scheduleJsons
        .map(
          (dynamic json) => Schedule.fromJson(json as Map<String, dynamic>),
        )
        .toList();

    List<User>? users;
    List<UserProject>? userProjects;

    if (res.containsKey('users')) {
      final userJsons = res['users'] as List<dynamic>;
      users = userJsons
          .map((dynamic json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    if (res.containsKey('user-projects')) {
      final userProjectJsons = res['user-projects'] as List<dynamic>;
      userProjects = userProjectJsons
          .map(
            (dynamic json) =>
                UserProject.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }
    _projectStreamController.add(projects);
    if (users != null) {
      _userStreamController.add(users);
    }
    if (userProjects != null) {
      _userProjectStreamController.add(userProjects);
    }
    _brokerStreamController.add(brokers);
    _groupStreamController.add(groups);
    _deviceStreamController.add(devices);
    _deviceTypeStreamController.add(deviceTypes);
    _attributeStreamController.add(attributes);
    _dashboardStreamController.add(dashboards);
    _tileStreamController.add(tiles);
    _alertStreamController.add(alerts);
    _conditionStreamController.add(conditions);
    _actionStreamController.add(actions);
    _logStreamController.add(logs);
    _conditionLogStreamController.add(conditionLogs);
    _actionTileStreamController.add(actionTiles);
    _scheduleStreamController.add(schedules);
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
      await getBrokers();
      await getDashboards();
      await getTiles();
      await getDevices();
      await getAttributes();
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
      await getUserProjects();
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
      await getDevices();
      await getAttributes();
      await getTiles();
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
      await getAttributes();
      await getTiles();
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
      await getAttributes();
      await getTiles();
      _deviceStreamController.add(devices);
    }
  }
  // ================== DEVICE REST API ========================

  // ================== DEVICE TYPE REST API ========================
  ///
  Stream<List<DeviceType>> subscribeDeviceTypeStream() {
    return _deviceTypeStreamController.asBroadcastStream();
  }

  /// create or update deviceType
  Future<void> saveDeviceType(DeviceType deviceType) async {
    if (_token == null) throw Exception('Token not found');
    final deviceTypes = [..._deviceTypeStreamController.value];
    final idx = deviceTypes.indexWhere((t) => t.id == deviceType.id);
    if (idx == -1) {
      await _apiClient.createDeviceType(
        token: _token!,
        deviceType: deviceType.toJson(),
      );
      deviceTypes.add(deviceType);
    } else {
      await _apiClient.updateDeviceType(
        token: _token!,
        deviceTypeID: deviceType.id,
        deviceType: deviceType.toJson(),
      );
      deviceTypes
        ..removeAt(idx)
        ..insertAll(idx, [deviceType]);
    }
    _deviceTypeStreamController.add(deviceTypes);
  }

  /// get deviceType list
  Future<void> getDeviceTypes() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getDeviceTypes(_token!);
    final deviceTypes = data
        .map(
          (dynamic json) => DeviceType.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    _deviceTypeStreamController.add(deviceTypes);
  }

  /// delete deviceType by ID
  Future<void> deleteDeviceType(String deviceTypeID) async {
    final deviceTypes = [..._deviceTypeStreamController.value];
    final idx = deviceTypes.indexWhere((t) => t.id == deviceTypeID);
    if (idx > -1) {
      await _apiClient.deleteDeviceType(
        token: _token!,
        deviceTypeID: deviceTypeID,
      );
      deviceTypes.removeAt(idx);
      await getAttributes();
      await getTiles();
      _deviceTypeStreamController.add(deviceTypes);
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
      await getTiles();
      _attributeStreamController.add(attributes);
    }
  }
  // ================== ATTRIBUTE REST API ========================

  // ================== DASHBOARD REST API ========================
  ///
  Stream<List<Dashboard>> subscribeDashboardStream() {
    return _dashboardStreamController.asBroadcastStream();
  }

  /// create or update dashboard
  Future<void> saveDashboard(Dashboard dashboard) async {
    if (_token == null) throw Exception('Token not found');
    final dashboards = [..._dashboardStreamController.value];
    final idx = dashboards.indexWhere((t) => t.id == dashboard.id);
    if (idx == -1) {
      await _apiClient.createDashboard(
        token: _token!,
        dashboard: dashboard.toJson(),
      );
      dashboards.add(dashboard);
    } else {
      await _apiClient.updateDashboard(
        token: _token!,
        dashboardID: dashboard.id,
        dashboard: dashboard.toJson(),
      );
      dashboards
        ..removeAt(idx)
        ..insertAll(idx, [dashboard]);
    }
    _dashboardStreamController.add(dashboards);
  }

  /// get dashboard list
  Future<void> getDashboards() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getDashboards(_token!);
    final dashboards = data
        .map((dynamic json) => Dashboard.fromJson(json as Map<String, dynamic>))
        .toList();
    _dashboardStreamController.add(dashboards);
  }

  /// delete dashboard by ID
  Future<void> deleteDashboard(String dashboardID) async {
    final dashboards = [..._dashboardStreamController.value];
    final idx = dashboards.indexWhere((t) => t.id == dashboardID);
    if (idx > -1) {
      await _apiClient.deleteDashboard(
        token: _token!,
        dashboardID: dashboardID,
      );
      dashboards.removeAt(idx);
      await getTiles();
      _dashboardStreamController.add(dashboards);
    }
  }
  // ================== DASHBOARD REST API ========================

  // ================== TILE REST API ========================
  ///
  Stream<List<Tile>> subscribeTileStream() {
    return _tileStreamController.asBroadcastStream();
  }

  /// create or update tile
  Future<void> saveTile(Tile tile) async {
    if (_token == null) throw Exception('Token not found');
    final tiles = [..._tileStreamController.value];
    final idx = tiles.indexWhere((t) => t.id == tile.id);
    if (idx == -1) {
      await _apiClient.createTile(
        token: _token!,
        tile: tile.toJson(),
      );
      tiles.add(tile);
    } else {
      await _apiClient.updateTile(
        token: _token!,
        tileID: tile.id,
        tile: tile.toJson(),
      );
      tiles
        ..removeAt(idx)
        ..insertAll(idx, [tile]);
    }
    _tileStreamController.add(tiles);
  }

  /// get tile list
  Future<void> getTiles() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getTiles(_token!);
    final tiles = data
        .map((dynamic json) => Tile.fromJson(json as Map<String, dynamic>))
        .toList();
    _tileStreamController.add(tiles);
  }

  /// delete tile by ID
  Future<void> deleteTile(String tileID) async {
    final tiles = [..._tileStreamController.value];
    final idx = tiles.indexWhere((t) => t.id == tileID);
    if (idx > -1) {
      await _apiClient.deleteTile(
        token: _token!,
        tileID: tileID,
      );
      tiles.removeAt(idx);
      _tileStreamController.add(tiles);
    }
  }
  // ================== TILE REST API ========================

  // ================== ALERT REST API ========================
  ///
  Stream<List<Alert>> subscribeAlertStream() {
    return _alertStreamController.asBroadcastStream();
  }

  /// create or update alert
  Future<void> saveAlert(Alert alert) async {
    if (_token == null) throw Exception('Token not found');
    final alerts = [..._alertStreamController.value];
    final idx = alerts.indexWhere((t) => t.id == alert.id);
    if (idx == -1) {
      await _apiClient.createAlert(
        token: _token!,
        alert: alert.toJson(),
      );
      alerts.add(alert);
    } else {
      await _apiClient.updateAlert(
        token: _token!,
        alertID: alert.id,
        alert: alert.toJson(),
      );
      alerts
        ..removeAt(idx)
        ..insertAll(idx, [alert]);
    }
    _alertStreamController.add(alerts);
  }

  /// get alert list
  Future<void> getAlerts() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getAlerts(_token!);
    final alerts = data
        .map((dynamic json) => Alert.fromJson(json as Map<String, dynamic>))
        .toList();
    _alertStreamController.add(alerts);
  }

  /// delete alert by ID
  Future<void> deleteAlert(String alertID) async {
    final alerts = [..._alertStreamController.value];
    final idx = alerts.indexWhere((t) => t.id == alertID);
    if (idx > -1) {
      await _apiClient.deleteAlert(
        token: _token!,
        alertID: alertID,
      );
      alerts.removeAt(idx);
      await getConditions();
      await getActions();
      _alertStreamController.add(alerts);
    }
  }
  // ================== ALERT REST API ========================

  // ================== CONDITION REST API ========================
  ///
  Stream<List<Condition>> subscribeConditionStream() {
    return _conditionStreamController.asBroadcastStream();
  }

  /// create or update condition
  Future<void> saveCondition(Condition condition) async {
    if (_token == null) throw Exception('Token not found');
    final conditions = [..._conditionStreamController.value];
    final idx = conditions.indexWhere((t) => t.id == condition.id);
    if (idx == -1) {
      await _apiClient.createCondition(
        token: _token!,
        condition: condition.toJson(),
      );
      conditions.add(condition);
    } else {
      await _apiClient.updateCondition(
        token: _token!,
        conditionID: condition.id,
        condition: condition.toJson(),
      );
      conditions
        ..removeAt(idx)
        ..insertAll(idx, [condition]);
    }
    _conditionStreamController.add(conditions);
  }

  /// get condition list
  Future<void> getConditions() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getConditions(_token!);
    final conditions = data
        .map((dynamic json) => Condition.fromJson(json as Map<String, dynamic>))
        .toList();
    _conditionStreamController.add(conditions);
  }

  /// delete condition by ID
  Future<void> deleteCondition(String conditionID) async {
    final conditions = [..._conditionStreamController.value];
    final idx = conditions.indexWhere((t) => t.id == conditionID);
    if (idx > -1) {
      await _apiClient.deleteCondition(
        token: _token!,
        conditionID: conditionID,
      );
      conditions.removeAt(idx);
      _conditionStreamController.add(conditions);
    }
  }
  // ================== CONDITION REST API ========================

  // ================== ACTION REST API ========================
  ///
  Stream<List<TAction>> subscribeActionStream() {
    return _actionStreamController.asBroadcastStream();
  }

  /// create or update action
  Future<void> saveAction(TAction action) async {
    if (_token == null) throw Exception('Token not found');
    final actions = [..._actionStreamController.value];
    final idx = actions.indexWhere((t) => t.id == action.id);
    if (idx == -1) {
      await _apiClient.createAction(
        token: _token!,
        action: action.toJson(),
      );
      actions.add(action);
    } else {
      await _apiClient.updateAction(
        token: _token!,
        actionID: action.id,
        action: action.toJson(),
      );
      actions
        ..removeAt(idx)
        ..insertAll(idx, [action]);
    }
    _actionStreamController.add(actions);
  }

  /// get action list
  Future<void> getActions() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getActions(_token!);
    final actions = data
        .map((dynamic json) => TAction.fromJson(json as Map<String, dynamic>))
        .toList();
    _actionStreamController.add(actions);
  }

  /// delete action by ID
  Future<void> deleteAction(String actionID) async {
    final actions = [..._actionStreamController.value];
    final idx = actions.indexWhere((t) => t.id == actionID);
    if (idx > -1) {
      await _apiClient.deleteAction(
        token: _token!,
        actionID: actionID,
      );
      actions.removeAt(idx);
      _actionStreamController.add(actions);
    }
  }
  // ================== ACTION REST API ========================

  // ================== SCHEDULE REST API ========================
  ///
  Stream<List<Schedule>> subscribeScheduleStream() {
    return _scheduleStreamController.asBroadcastStream();
  }

  /// create or update schedule
  Future<void> saveSchedule(Schedule schedule) async {
    if (_token == null) throw Exception('Token not found');
    final schedules = [..._scheduleStreamController.value];
    final idx = schedules.indexWhere((t) => t.id == schedule.id);
    if (idx == -1) {
      await _apiClient.createSchedule(
        token: _token!,
        schedule: schedule.toJson(),
      );
      schedules.add(schedule);
    } else {
      await _apiClient.updateSchedule(
        token: _token!,
        scheduleID: schedule.id,
        schedule: schedule.toJson(),
      );
      schedules
        ..removeAt(idx)
        ..insertAll(idx, [schedule]);
    }
    _scheduleStreamController.add(schedules);
  }

  /// get schedule list
  Future<void> getSchedules() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getSchedules(_token!);
    final schedules = data
        .map((dynamic json) => Schedule.fromJson(json as Map<String, dynamic>))
        .toList();
    _scheduleStreamController.add(schedules);
  }

  /// delete schedule by ID
  Future<void> deleteSchedule(String scheduleID) async {
    final schedules = [..._scheduleStreamController.value];
    final idx = schedules.indexWhere((t) => t.id == scheduleID);
    if (idx > -1) {
      await _apiClient.deleteSchedule(
        token: _token!,
        scheduleID: scheduleID,
      );
      schedules.removeAt(idx);
      _scheduleStreamController.add(schedules);
    }
  }
  // ================== ACTION REST API ========================

  // ================== ACTION TILE REST API ========================
  ///
  Stream<List<ActionTile>> subscribeActionTileStream() {
    return _actionTileStreamController.asBroadcastStream();
  }

  /// create or update action
  Future<void> saveActionTile(ActionTile action) async {
    if (_token == null) throw Exception('Token not found');
    final actionTiles = [..._actionTileStreamController.value];
    final idx = actionTiles.indexWhere((t) => t.id == action.id);
    if (idx == -1) {
      await _apiClient.createAction(
        token: _token!,
        action: action.toJson(),
      );
      actionTiles.add(action);
    } else {
      await _apiClient.updateAction(
        token: _token!,
        actionID: action.id,
        action: action.toJson(),
      );
      actionTiles
        ..removeAt(idx)
        ..insertAll(idx, [action]);
    }
    _actionTileStreamController.add(actionTiles);
  }

  /// get action list
  Future<void> getActionTiles() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getActions(_token!);
    final actionTiles = data
        .map(
          (dynamic json) => ActionTile.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    _actionTileStreamController.add(actionTiles);
  }

  /// delete action by ID
  Future<void> deleteActionTile(String actionID) async {
    final actionTiles = [..._actionTileStreamController.value];
    final idx = actionTiles.indexWhere((t) => t.id == actionID);
    if (idx > -1) {
      await _apiClient.deleteAction(
        token: _token!,
        actionID: actionID,
      );
      actionTiles.removeAt(idx);
      _actionTileStreamController.add(actionTiles);
    }
  }
  // ================== ACTION TILE REST API ========================

  // ================== LOG REST API ========================
  ///
  Stream<List<Log>> subscribeLogStream() {
    return _logStreamController.asBroadcastStream();
  }

  /// get log list
  Future<void> getLogs() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getLogs(_token!);
    final logs = data
        .map((dynamic json) => Log.fromJson(json as Map<String, dynamic>))
        .toList();
    _logStreamController.add(logs);
  }
  // ================== LOG REST API ========================

  // ================== CONDITION LOG REST API ========================
  ///
  Stream<List<ConditionLog>> subscribeConditionLogStream() {
    return _conditionLogStreamController.asBroadcastStream();
  }

  /// get conditionLog list
  Future<void> getConditionLogs() async {
    if (_token == null) throw Exception('Token not found');
    final data = await _apiClient.getConditionLogs(_token!);
    final conditionLogs = data
        .map(
          (dynamic json) => ConditionLog.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    _conditionLogStreamController.add(conditionLogs);
  }
  // ================== CONDITION LOG REST API ========================

  // ================== RECORD REST API ========================
  ///
  /// get conditionLog list
  Future<Map<String, dynamic>> getRecords(String deviceID) async {
    if (_token == null) throw Exception('Token not found');
    final data =
        await _apiClient.getRecords(token: _token!, deviceID: deviceID);
    return data;
  }
  // ================== RECORD REST API ========================
}

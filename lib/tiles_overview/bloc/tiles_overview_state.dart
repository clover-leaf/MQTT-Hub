part of 'tiles_overview_bloc.dart';

enum TilesOverviewStatus {
  processing,
  normal,
  success,
  failure,
}

extension TilesOverviewStatusX on TilesOverviewStatus {
  bool isProcessing() => this == TilesOverviewStatus.processing;
  bool isSuccess() => this == TilesOverviewStatus.success;
  bool isFailure() => this == TilesOverviewStatus.failure;
}

class TilesOverviewState extends Equatable {
  TilesOverviewState({
    required this.isAdmin,
    this.isLogout = false,
    this.status = TilesOverviewStatus.normal,
    this.error,
    this.selectedProjectID,
    this.projectDashboardView = const {},
    this.gatewayClientView = const {},
    this.brokerTopicPayloads = const {},
    this.tileValueView = const {},
    this.tileUpdateView = const {},
    this.brokerStatusView = const {},
    this.brokers = const [],
    this.projects = const [],
    this.dashboards = const [],
    this.tiles = const [],
    this.actions = const [],
    this.deviceTypes = const [],
    this.devices = const [],
    this.attributes = const [],
  });

  /// cho biết người dùng là admin hay ko
  final bool isAdmin;

  final bool isLogout;

  // === Update manually ===
  /// trạng thái của trang
  final TilesOverviewStatus status;
  final String? error;

  /// ID của project đang chọn
  final FieldId? selectedProjectID;

  /// <ProjectID, DashboardID>
  /// cặp project ID và dashboard ID
  /// để biết ở project nào thì hiện dashboard nào
  /// phụ thuộc projects, dashboards
  final Map<FieldId, FieldId?> projectDashboardView;

  /// <BrokerID, GatewayClient>
  /// cặp project ID và gateway client
  /// phụ thuộc brokers
  final Map<FieldId, GatewayClient> gatewayClientView;

  /// <BrokerID, <Topic, Payload>>
  /// giá trị phụ thuộc vào brokers, devices
  final Map<FieldId, Map<String, String?>> brokerTopicPayloads;

  /// <TileID, value?>
  /// cặp tile ID và giá trị của tile đó
  /// phụ thuộc tiles
  final Map<FieldId, String?> tileValueView;
  /// <TileID, value?>
  /// cặp tile ID và chỉ báo cho biết nhận
  /// được giá trị mới
  final Map<FieldId, bool?> tileUpdateView;

  // === Update by stream ===
  /// <BrokerID, GatewayClient>
  final Map<FieldId, ConnectionStatus> brokerStatusView;
  final List<Broker> brokers;
  final List<Project> projects;
  final List<Dashboard> dashboards;
  final List<Tile> tiles;
  final List<TAction> actions;
  final List<DeviceType> deviceTypes;
  final List<Device> devices;
  final List<Attribute> attributes;

  late final Map<FieldId, Project> projectView = {
    for (final pr in projects) pr.id: pr
  };

  late final Map<FieldId, Dashboard> dashboardView = {
    for (final db in dashboards) db.id: db
  };

  late final Map<FieldId, Broker> brokerView = {
    for (final br in brokers) br.id: br
  };

  late final Map<FieldId, Tile> tileView = {for (final tl in tiles) tl.id: tl};

  late final Map<FieldId, Device> deviceView = {
    for (final dv in devices) dv.id: dv
  };

  late final Map<FieldId, Attribute> attributeView = {
    for (final att in attributes) att.id: att
  };

  List<Dashboard> get showedDashboards {
    return dashboards.where((db) => db.projectID == selectedProjectID).toList();
  }

  List<Device> get devicesInSelectedProject {
    final brokerIDsInProject = brokers
        .where((br) => br.projectID == selectedProjectID)
        .map((br) => br.id);
    final devicesInProject = devices
        .where((dv) => brokerIDsInProject.contains(dv.brokerID))
        .toList();
    return devicesInProject;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        isLogout,
        status,
        selectedProjectID,
        projectDashboardView,
        gatewayClientView,
        brokerTopicPayloads,
        tileValueView,
        tileUpdateView,
        brokerStatusView,
        brokers,
        projects,
        dashboards,
        tiles,
        actions,
        devices,
        deviceTypes,
        attributes,
        error
      ];

  TilesOverviewState copyWith({
    bool? isAdmin,
    bool? isLogout,
    TilesOverviewStatus? status,
    String? Function()? error,
    FieldId? Function()? selectedProjectID,
    Map<FieldId, FieldId?>? projectDashboardView,
    Map<FieldId, GatewayClient>? gatewayClientView,
    Map<FieldId, Map<String, String?>>? brokerTopicPayloads,
    Map<FieldId, String?>? tileValueView,
    Map<FieldId, bool?>? tileUpdateView,
    Map<FieldId, ConnectionStatus>? brokerStatusView,
    List<Broker>? brokers,
    List<Project>? projects,
    List<Dashboard>? dashboards,
    List<Tile>? tiles,
    List<TAction>? actions,
    List<DeviceType>? deviceTypes,
    List<Device>? devices,
    List<Attribute>? attributes,
  }) {
    return TilesOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      isLogout: isLogout ?? this.isLogout,
      status: status ?? this.status,
      error: error != null ? error() : this.error,
      selectedProjectID: selectedProjectID != null
          ? selectedProjectID()
          : this.selectedProjectID,
      projectDashboardView: projectDashboardView ?? this.projectDashboardView,
      gatewayClientView: gatewayClientView ?? this.gatewayClientView,
      brokerTopicPayloads: brokerTopicPayloads ?? this.brokerTopicPayloads,
      tileValueView: tileValueView ?? this.tileValueView,
      tileUpdateView: tileUpdateView ?? this.tileUpdateView,
      brokerStatusView: brokerStatusView ?? this.brokerStatusView,
      brokers: brokers ?? this.brokers,
      projects: projects ?? this.projects,
      dashboards: dashboards ?? this.dashboards,
      tiles: tiles ?? this.tiles,
      actions: actions ?? this.actions,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
    );
  }
}

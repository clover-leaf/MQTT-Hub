part of 'project_detail_bloc.dart';

enum ProjectDetailStatus {
  normal,
  processing,
  success,
  failure,
}

extension ProjectDetailStatusX on ProjectDetailStatus {
  bool isProcessing() => this == ProjectDetailStatus.processing;
  bool isSuccess() => this == ProjectDetailStatus.success;
  bool isFailure() => this == ProjectDetailStatus.failure;
}

class ProjectDetailState extends Equatable {
  const ProjectDetailState({
    required this.isAdmin,
    this.status = ProjectDetailStatus.normal,
    required this.project,
    this.groups = const [],
    this.brokers = const [],
    this.userProjects = const [],
    this.dashboards = const [],
    this.devices = const [],
    this.deviceTypes = const [],
    this.alerts = const [],
    this.schedules = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project project;

  // listen
  final List<Group> groups;
  final List<Broker> brokers;
  final List<UserProject> userProjects;
  final List<Dashboard> dashboards;
  final List<Device> devices;
  final List<DeviceType> deviceTypes;
  final List<Alert> alerts;
  final List<Schedule> schedules;

  // status
  final ProjectDetailStatus status;
  final String? error;

  int get groupNumber {
    final _groups = groups.where((gr) => gr.projectID == project.id).toList();
    return _groups.length;
  }

  List<Broker> get brokerInProject =>
      brokers.where((br) => br.projectID == project.id).toList();

  int get brokerNumber => brokerInProject.length;

  Map<String, Device> get deviceView => {for (final dv in devices) dv.id: dv};

  int get dashboardNumber {
    final _dashboards =
        dashboards.where((db) => db.projectID == project.id).toList();
    return _dashboards.length;
  }

  int get userNumber {
    final _users =
        userProjects.where((usPr) => usPr.projectID == project.id).toList();
    return _users.length;
  }

  int get alertNumber {
    final brokerIdInProject = brokerInProject.map((br) => br.id);
    final _alerts = alerts.where((al) {
      final device = deviceView[al.deviceID];
      return brokerIdInProject.contains(device?.brokerID);
    }).toList();
    return _alerts.length;
  }

  int get deviceTypeNumber {
    final _dvT =
        deviceTypes.where((dT) => dT.projectID == project.id).toList();
    return _dvT.length;
  }

  int get scheduleNumber {
    final _sc =
        schedules.where((sc) => sc.projectID == project.id).toList();
    return _sc.length;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        status,
        project,
        groups,
        brokers,
        userProjects,
        dashboards,
        devices,
        deviceTypes,
        alerts,
        schedules,
        error
      ];

  ProjectDetailState copyWith({
    bool? isAdmin,
    ProjectDetailStatus? status,
    Project? project,
    List<Group>? groups,
    List<Broker>? brokers,
    List<UserProject>? userProjects,
    List<Dashboard>? dashboards,
    List<Device>? devices,
    List<DeviceType>? deviceTypes,
    List<Alert>? alerts,
    List<Schedule>? schedules,
    String? Function()? error,
  }) {
    return ProjectDetailState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      project: project ?? this.project,
      groups: groups ?? this.groups,
      brokers: brokers ?? this.brokers,
      userProjects: userProjects ?? this.userProjects,
      dashboards: dashboards ?? this.dashboards,
      devices: devices ?? this.devices,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      alerts: alerts ?? this.alerts,
      schedules: schedules ?? this.schedules,
      error: error != null ? error() : this.error,
    );
  }
}

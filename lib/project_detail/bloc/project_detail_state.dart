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
    required this.projectID,
    this.projects = const [],
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
  final String projectID;

  // listen
  final List<Project> projects;
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
    final _groups = groups.where((gr) => gr.projectID == projectID).toList();
    return _groups.length;
  }

  List<Broker> get brokerInProject =>
      brokers.where((br) => br.projectID == projectID).toList();

  int get brokerNumber => brokerInProject.length;

  Map<String, Project> get projectView => {for (final pj in projects) pj.id: pj};

  Map<String, Device> get deviceView => {for (final dv in devices) dv.id: dv};

  Project? get curProject => projectView[projectID];

  int get dashboardNumber {
    final _dashboards =
        dashboards.where((db) => db.projectID == projectID).toList();
    return _dashboards.length;
  }

  int get userNumber {
    final _users =
        userProjects.where((usPr) => usPr.projectID == projectID).toList();
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
        deviceTypes.where((dT) => dT.projectID == projectID).toList();
    return _dvT.length;
  }

  int get scheduleNumber {
    final _sc =
        schedules.where((sc) => sc.projectID == projectID).toList();
    return _sc.length;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        status,
        projectID,
        projects,
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
    String? projectID,
    List<Project>? projects,
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
      projectID: projectID ?? this.projectID,
      projects: projects ?? this.projects,
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

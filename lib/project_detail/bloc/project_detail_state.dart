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

  // status
  final ProjectDetailStatus status;
  final String? error;

  int get groupNumber {
    final _groups = groups.where((gr) => gr.projectID == project.id).toList();
    return _groups.length;
  }

  int get brokerNumber {
    final _brokers = brokers.where((br) => br.projectID == project.id).toList();
    return _brokers.length;
  }

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

  @override
  List<Object?> get props => [
        isAdmin,
        status,
        project,
        groups,
        brokers,
        userProjects,
        dashboards,
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
      error: error != null ? error() : this.error,
    );
  }
}

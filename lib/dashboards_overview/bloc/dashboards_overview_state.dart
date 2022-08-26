part of 'dashboards_overview_bloc.dart';

enum DashboardsOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension DashboardsOverviewStatusX on DashboardsOverviewStatus {
  bool isProcessing() => this == DashboardsOverviewStatus.processing;
  bool isSuccess() => this == DashboardsOverviewStatus.success;
  bool isFailure() => this == DashboardsOverviewStatus.failure;
}

class DashboardsOverviewState extends Equatable {
  const DashboardsOverviewState({
    required this.isAdmin,
    this.status = DashboardsOverviewStatus.normal,
    required this.parentProject,
    this.dashboards = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project parentProject;

  // listen
  final List<Dashboard> dashboards;

  // status
  final DashboardsOverviewStatus status;
  final String? error;

  List<Dashboard> get showedDashboard =>
      dashboards.where((db) => db.projectID == parentProject.id).toList();

  @override
  List<Object?> get props =>
      [isAdmin, status, dashboards, parentProject, error];

  DashboardsOverviewState copyWith({
    bool? isAdmin,
    DashboardsOverviewStatus? status,
    Project? parentProject,
    List<Dashboard>? dashboards,
    String? Function()? error,
  }) {
    return DashboardsOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      dashboards: dashboards ?? this.dashboards,
      error: error != null ? error() : this.error,
    );
  }
}

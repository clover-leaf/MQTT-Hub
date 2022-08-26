part of 'projects_overview_bloc.dart';

class ProjectsOverviewState extends Equatable {
  const ProjectsOverviewState({
    required this.isAdmin,
    this.projects = const [],
    this.brokers = const [],
    this.userProjects = const [],
    this.dashboards = const [],
  });

  // immutate
  final bool isAdmin;

  // listen
  final List<Project> projects;
  final List<Broker> brokers;
  final List<UserProject> userProjects;
  final List<Dashboard> dashboards;

  ProjectsOverviewState copyWith({
    bool? isAdmin,
    List<Project>? projects,
    List<Broker>? brokers,
    List<UserProject>? userProjects,
    List<Dashboard>? dashboards,
  }) {
    return ProjectsOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      projects: projects ?? this.projects,
      brokers: brokers ?? this.brokers,
      userProjects: userProjects ?? this.userProjects,
      dashboards: dashboards ?? this.dashboards,
    );
  }

  @override
  List<Object> get props =>
      [isAdmin, projects, brokers, userProjects, dashboards];
}

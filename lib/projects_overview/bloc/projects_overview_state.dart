part of 'projects_overview_bloc.dart';

class ProjectsOverviewState extends Equatable {
  const ProjectsOverviewState({this.projects = const []});

  final List<Project> projects;

  ProjectsOverviewState copyWith({
    List<Project>? projects,
  }) {
    return ProjectsOverviewState(projects: projects ?? this.projects);
  }

  @override
  List<Object> get props => [projects];
}

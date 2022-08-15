part of 'project_detail_bloc.dart';

class ProjectDetailState extends Equatable {
  const ProjectDetailState({
    required this.project,
  });

  final Project project;

  @override
  List<Object> get props => [project];

  ProjectDetailState copyWith({
    Project? project,
  }) {
    return ProjectDetailState(
      project: project ?? this.project,
    );
  }
}

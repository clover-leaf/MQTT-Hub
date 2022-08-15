part of 'groups_overview_bloc.dart';

class GroupsOverviewState extends Equatable {
  const GroupsOverviewState({
    required this.project,
    this.groups = const [],
  });

  final Project project;
  final List<Group> groups;

  List<Group> get rootGroup =>
      groups.where((gr) => gr.projectID == project.id).toList();


  GroupsOverviewState copyWith({
    Project? project,
    List<Group>? groups,
  }) {
    return GroupsOverviewState(
      project: project ?? this.project,
      groups: groups ?? this.groups,
    );
  }

  @override
  List<Object> get props => [project, groups];
}

part of 'groups_overview_bloc.dart';

class GroupsOverviewState extends Equatable {
  const GroupsOverviewState({
    required this.isAdmin,
    required this.parentProject,
    this.groups = const [],
    this.devices = const [],
  });

  // immutate
  final bool isAdmin;
  final Project parentProject;

  // listen
  final List<Group> groups;
  final List<Device> devices;

  List<Group> get showedGroup =>
      groups.where((gr) => gr.projectID == parentProject.id).toList();

  GroupsOverviewState copyWith({
    bool? isAdmin,
    Project? parentProject,
    List<Group>? groups,
    List<Device>? devices,
  }) {
    return GroupsOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      parentProject: parentProject ?? this.parentProject,
      groups: groups ?? this.groups,
      devices: devices ?? this.devices,
    );
  }

  @override
  List<Object> get props => [isAdmin, parentProject, groups, devices];
}

part of 'group_detail_bloc.dart';

class GroupDetailState extends Equatable {
  const GroupDetailState({
    required this.path,
    required this.rootProject,
    required this.group,
    this.groups = const [],
    this.devices = const [],
  });

  final String path;
  final Project rootProject;
  final Group group;
  final List<Group> groups;
  final List<Device> devices;

  List<Group> get childGroup =>
      groups.where((gr) => gr.groupID == group.id).toList();

  List<Device> get childDevice =>
      devices.where((dv) => dv.groupID == group.id).toList();

  @override
  List<Object?> get props => [path, rootProject, group, groups, devices];

  GroupDetailState copyWith({
    String? path,
    Project? rootProject,
    Group? group,
    List<Group>? groups,
    List<Device>? devices,
  }) {
    return GroupDetailState(
      path: path ?? this.path,
      rootProject: rootProject ?? this.rootProject,
      group: group ?? this.group,
      groups: groups ?? this.groups,
      devices: devices ?? this.devices,
    );
  }
}

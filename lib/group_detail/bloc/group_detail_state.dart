part of 'group_detail_bloc.dart';

class GroupDetailState extends Equatable {
  const GroupDetailState({
    required this.group,
    required this.parentProject,
    required this.parentGroup,
    this.groups = const [],
    this.devices = const [],
  });

  final Group group;
  final Project? parentProject;
  final Group? parentGroup;
  final List<Group> groups;
  final List<Device> devices;

  List<Group> get childGroup =>
      groups.where((gr) => gr.groupID == group.id).toList();

  List<Device> get childDevice =>
      devices.where((dv) => dv.groupID == group.id).toList();

  @override
  List<Object?> get props =>
      [group, parentProject, parentGroup, groups, devices];

  GroupDetailState copyWith({
    Group? group,
    Project? parentProject,
    Group? parentGroup,
    List<Group>? groups,
    List<Device>? devices,
  }) {
    return GroupDetailState(
      group: group ?? this.group,
      parentProject: parentProject ?? this.parentProject,
      parentGroup: parentGroup ?? this.parentGroup,
      groups: groups ?? this.groups,
      devices: devices ?? this.devices,
    );
  }
}

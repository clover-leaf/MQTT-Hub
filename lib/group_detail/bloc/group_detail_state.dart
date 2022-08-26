part of 'group_detail_bloc.dart';

enum GroupDetailStatus {
  normal,
  processing,
  success,
  failure,
}

extension GroupDetailStatusX on GroupDetailStatus {
  bool isProcessing() => this == GroupDetailStatus.processing;
  bool isSuccess() => this == GroupDetailStatus.success;
  bool isFailure() => this == GroupDetailStatus.failure;
}

class GroupDetailState extends Equatable {
  const GroupDetailState({
    required this.isAdmin,
    this.status = GroupDetailStatus.normal,
    required this.rootProject,
    required this.group,
    this.brokers = const [],
    this.groups = const [],
    this.devices = const [],
    this.isShowGroup = false,
    this.isShowDevice = false,
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project rootProject;
  final Group group;

  // listen
  final List<Broker> brokers;
  final List<Group> groups;
  final List<Device> devices;

  // status
  final bool isShowGroup;
  final bool isShowDevice;
  final GroupDetailStatus status;
  final String? error;

  List<Group> get childrenGroups =>
      groups.where((gr) => gr.groupID == group.id).toList();

  List<Device> get childrenDevices =>
      devices.where((dv) => dv.groupID == group.id).toList();

  int get groupNumber {
    final _groups = groups.where((gr) => gr.groupID == group.id).toList();
    return _groups.length;
  }

  List<Broker> get brokerInProjects =>
      brokers.where((br) => br.projectID == rootProject.id).toList();

  int get deviceNumber {
    final _devices = devices.where((dv) => dv.groupID == group.id).toList();
    return _devices.length;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        status,
        rootProject,
        group,
        brokers,
        groups,
        devices,
        isShowGroup,
        isShowDevice,
        error
      ];

  GroupDetailState copyWith({
    bool? isAdmin,
    GroupDetailStatus? status,
    Project? rootProject,
    Group? group,
    List<Broker>? brokers,
    List<Group>? groups,
    List<Device>? devices,
    bool? isShowGroup,
    bool? isShowDevice,
    String? Function()? error,
  }) {
    return GroupDetailState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      rootProject: rootProject ?? this.rootProject,
      group: group ?? this.group,
      brokers: brokers ?? this.brokers,
      groups: groups ?? this.groups,
      devices: devices ?? this.devices,
      isShowGroup: isShowGroup ?? this.isShowGroup,
      isShowDevice: isShowDevice ?? this.isShowDevice,
      error: error != null ? error() : this.error,
    );
  }
}

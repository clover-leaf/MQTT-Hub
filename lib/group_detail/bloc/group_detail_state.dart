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
    required this.groupID,
    this.brokers = const [],
    this.groups = const [],
    this.deviceTypes = const [],
    this.devices = const [],
    this.attributes = const [],
    this.isShowGroup = false,
    this.isShowDevice = false,
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project rootProject;
  final String groupID;

  // listen
  final List<Broker> brokers;
  final List<Group> groups;
  final List<DeviceType> deviceTypes;
  final List<Device> devices;
  final List<Attribute> attributes;

  // status
  final bool isShowGroup;
  final bool isShowDevice;
  final GroupDetailStatus status;
  final String? error;

  Map<String, Group> get groupView => {for (final gr in groups) gr.id: gr};

  Group? get curGroup => groupView[groupID];

  List<Group> get childrenGroups =>
      groups.where((gr) => gr.groupID == groupID).toList();

  List<Device> get childrenDevices =>
      devices.where((dv) => dv.groupID == groupID).toList();

  int get groupNumber {
    final _groups = groups.where((gr) => gr.groupID == groupID).toList();
    return _groups.length;
  }

  List<Broker> get brokerInProjects =>
      brokers.where((br) => br.projectID == rootProject.id).toList();

  List<DeviceType> get deviceTypeInProjects =>
      deviceTypes.where((dT) => dT.projectID == rootProject.id).toList();

  int get deviceNumber {
    final _devices = devices.where((dv) => dv.groupID == groupID).toList();
    return _devices.length;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        status,
        rootProject,
        groupID,
        brokers,
        groups,
        deviceTypes,
        devices,
        attributes,
        isShowGroup,
        isShowDevice,
        error
      ];

  GroupDetailState copyWith({
    bool? isAdmin,
    GroupDetailStatus? status,
    Project? rootProject,
    String? groupID,
    List<Broker>? brokers,
    List<Group>? groups,
    List<DeviceType>? deviceTypes,
    List<Device>? devices,
    List<Attribute>? attributes,
    bool? isShowGroup,
    bool? isShowDevice,
    String? Function()? error,
  }) {
    return GroupDetailState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      rootProject: rootProject ?? this.rootProject,
      groupID: groupID ?? this.groupID,
      brokers: brokers ?? this.brokers,
      groups: groups ?? this.groups,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      isShowGroup: isShowGroup ?? this.isShowGroup,
      isShowDevice: isShowDevice ?? this.isShowDevice,
      error: error != null ? error() : this.error,
    );
  }
}

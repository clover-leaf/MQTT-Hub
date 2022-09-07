part of 'device_types_overview_bloc.dart';

enum DeviceTypesOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension DeviceTypesOverviewStatusX on DeviceTypesOverviewStatus {
  bool isProcessing() => this == DeviceTypesOverviewStatus.processing;
  bool isSuccess() => this == DeviceTypesOverviewStatus.success;
  bool isFailure() => this == DeviceTypesOverviewStatus.failure;
}

class DeviceTypesOverviewState extends Equatable {
  const DeviceTypesOverviewState({
    required this.isAdmin,
    this.status = DeviceTypesOverviewStatus.normal,
    required this.parentProject,
    this.deviceTypes = const [],
    this.attributes = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project parentProject;

  // listen
  final List<DeviceType> deviceTypes;
  final List<Attribute> attributes;

  // status
  final DeviceTypesOverviewStatus status;
  final String? error;

  List<DeviceType> get showedDeviceTypes =>
      deviceTypes.where((dT) => dT.projectID == parentProject.id).toList();

  @override
  List<Object?> get props =>
      [isAdmin, status, parentProject, deviceTypes, attributes, error];

  DeviceTypesOverviewState copyWith({
    bool? isAdmin,
    DeviceTypesOverviewStatus? status,
    Project? parentProject,
    List<DeviceType>? deviceTypes,
    List<Attribute>? attributes,
    String? Function()? error,
  }) {
    return DeviceTypesOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      attributes: attributes ?? this.attributes,
      error: error != null ? error() : this.error,
    );
  }
}

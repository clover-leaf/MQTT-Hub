part of 'device_detail_bloc.dart';

enum DeviceDetailStatus {
  normal,
  processing,
  success,
  failure,
}

extension DeviceDetailStatusX on DeviceDetailStatus {
  bool isProcessing() => this == DeviceDetailStatus.processing;
  bool isSuccess() => this == DeviceDetailStatus.success;
  bool isFailure() => this == DeviceDetailStatus.failure;
}

class DeviceDetailState extends Equatable {
  const DeviceDetailState({
    required this.isAdmin,
    required this.rootProject,
    this.status = DeviceDetailStatus.normal,
    required this.device,
    this.attributes = const [],
    this.brokers = const [],
    this.devices = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project rootProject;
  final Device device;

  // listen
  final List<Attribute> attributes;
  final List<Broker> brokers;
  final List<Device> devices;

  // status
  final DeviceDetailStatus status;
  final String? error;

  List<Attribute> get showedAttributes =>
      attributes.where((attr) => attr.deviceID == device.id).toList();

  List<Broker> get brokerInProjects =>
      brokers.where((br) => br.projectID == rootProject.id).toList();

  @override
  List<Object?> get props => [
        isAdmin,
        rootProject,
        device,
        attributes,
        brokers,
        devices,
        status,
        error
      ];

  DeviceDetailState copyWith({
    bool? isAdmin,
    Project? rootProject,
    Device? device,
    List<Attribute>? attributes,
    List<Broker>? brokers,
    List<Device>? devices,
    DeviceDetailStatus? status,
    String? Function()? error,
  }) {
    return DeviceDetailState(
      isAdmin: isAdmin ?? this.isAdmin,
      rootProject: rootProject ?? this.rootProject,
      status: status ?? this.status,
      device: device ?? this.device,
      attributes: attributes ?? this.attributes,
      brokers: brokers ?? this.brokers,
      devices: devices ?? this.devices,
      error: error != null ? error() : this.error,
    );
  }
}

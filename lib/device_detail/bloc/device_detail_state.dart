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
    this.deviceTypes = const [],
    this.devices = const [],
    this.trackingDevices = const [],
    this.trackingAttributes = const [],
    this.error,
    this.isDeleted = false,
  });

  // immutate
  final bool isAdmin;
  final Project rootProject;
  final Device device;

  // listen
  final List<Attribute> attributes;
  final List<Broker> brokers;
  final List<DeviceType> deviceTypes;
  final List<Device> devices;
  final List<TrackingDevice> trackingDevices;
  final List<TrackingAttribute> trackingAttributes;

  // status
  final DeviceDetailStatus status;
  final bool isDeleted;
  final String? error;

  List<Attribute> get showedAttributes => attributes.where((attr) {
        if (device.deviceTypeID != null) {
          return attr.deviceTypeID == device.deviceTypeID;
        } else {
          return attr.deviceID == device.id;
        }
      }).toList();

  List<Broker> get brokerInProjects =>
      brokers.where((br) => br.projectID == rootProject.id).toList();

  List<DeviceType> get deviceTypeInProjects =>
      deviceTypes.where((dT) => dT.projectID == rootProject.id).toList();

  @override
  List<Object?> get props => [
        isAdmin,
        rootProject,
        device,
        attributes,
        trackingDevices,
        trackingAttributes,
        brokers,
        deviceTypes,
        devices,
        status,
        error,
        isDeleted,
      ];

  DeviceDetailState copyWith({
    bool? isAdmin,
    Project? rootProject,
    Device? device,
    List<Attribute>? attributes,
    List<TrackingDevice>? trackingDevices,
    List<TrackingAttribute>? trackingAttributes,
    List<Broker>? brokers,
    List<DeviceType>? deviceTypes,
    List<Device>? devices,
    DeviceDetailStatus? status,
    String? Function()? error,
    bool? isDeleted,
  }) {
    return DeviceDetailState(
      isAdmin: isAdmin ?? this.isAdmin,
      rootProject: rootProject ?? this.rootProject,
      status: status ?? this.status,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      device: device ?? this.device,
      attributes: attributes ?? this.attributes,
      trackingDevices: trackingDevices ?? this.trackingDevices,
      trackingAttributes: trackingAttributes ?? this.trackingAttributes,
      brokers: brokers ?? this.brokers,
      devices: devices ?? this.devices,
      error: error != null ? error() : this.error,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

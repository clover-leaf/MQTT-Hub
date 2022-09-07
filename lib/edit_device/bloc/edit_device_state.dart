part of 'edit_device_bloc.dart';

enum EditDeviceStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditDeviceStatusX on EditDeviceStatus {
  bool isProcessing() => this == EditDeviceStatus.processing;
  bool isSuccess() => this == EditDeviceStatus.success;
  bool isFailure() => this == EditDeviceStatus.failure;
}

class EditDeviceState extends Equatable {
  const EditDeviceState({
    this.status = EditDeviceStatus.normal,
    required this.id,
    required this.isEdit,
    required this.isAdmin,
    required this.brokers,
    required this.deviceTypes,
    required this.parentGroupID,
    required this.initialAttributes,
    required this.attributes,
    required this.allAttributes,
    required this.isUseDeviceType,
    this.name = '',
    this.topic = '',
    this.qos = 0,
    this.description,
    this.selectedBrokerID,
    this.selectedDeviceTypeID,
    this.initialDevice,
    this.error,
  });

  // immutate
  final String id;
  final List<Broker> brokers;
  final List<DeviceType> deviceTypes;
  final String parentGroupID;
  final List<Attribute> allAttributes;
  final List<Attribute> initialAttributes;

  // choose
  final String? selectedBrokerID;
  final String? selectedDeviceTypeID;
  final bool isUseDeviceType;

  // input
  final String name;
  final String topic;
  final String? description;
  final List<Attribute> attributes;
  final int qos;

  // status
  final EditDeviceStatus status;
  final bool isEdit;
  final bool isAdmin;
  final String? error;

  // initial
  final Device? initialDevice;

  @override
  List<Object?> get props => [
        id,
        parentGroupID,
        brokers,
        allAttributes,
        deviceTypes,
        initialAttributes,
        attributes,
        name,
        qos,
        topic,
        description,
        selectedBrokerID,
        selectedDeviceTypeID,
        initialDevice,
        status,
        isUseDeviceType,
        error
      ];

  EditDeviceState copyWith({
    String? id,
    String? parentGroupID,
    List<Broker>? brokers,
    List<DeviceType>? deviceTypes,
    List<Attribute>? initialAttributes,
    List<Attribute>? attributes,
    List<Attribute>? allAttributes,
    String? name,
    String? topic,
    int? qos,
    String? description,
    String? selectedBrokerID,
    String? Function()? selectedDeviceTypeID,
    String? tempAttributeName,
    String? tempAttributeJsonPath,
    EditDeviceStatus? status,
    Device? initialDevice,
    bool? isUseDeviceType,
    bool? isEdit,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return EditDeviceState(
      id: id ?? this.id,
      isEdit: isEdit ?? this.isEdit,
      isAdmin: isAdmin ?? this.isAdmin,
      parentGroupID: parentGroupID ?? this.parentGroupID,
      initialAttributes: initialAttributes ?? this.initialAttributes,
      allAttributes: allAttributes ?? this.allAttributes,
      attributes: attributes ?? this.attributes,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      qos: qos ?? this.qos,
      description: description ?? this.description,
      selectedBrokerID: selectedBrokerID ?? this.selectedBrokerID,
      selectedDeviceTypeID: selectedDeviceTypeID != null
          ? selectedDeviceTypeID()
          : this.selectedDeviceTypeID,
      brokers: brokers ?? this.brokers,
      deviceTypes: deviceTypes ?? this.deviceTypes,
      status: status ?? this.status,
      initialDevice: initialDevice ?? this.initialDevice,
      isUseDeviceType: isUseDeviceType ?? this.isUseDeviceType,
      error: error != null ? error() : this.error,
    );
  }
}

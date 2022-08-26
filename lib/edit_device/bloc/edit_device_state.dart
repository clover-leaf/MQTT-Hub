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
    required this.brokers,
    required this.parentGroupID,
    required this.initialAttributes,
    required this.attributes,
    this.name = '',
    this.topic = '',
    this.selectedBrokerID,
    this.initialDevice,
    this.error,
  });

  // immutate
  final String id;
  final List<Broker> brokers;
  final String parentGroupID;
  final List<Attribute> initialAttributes;

  // choose
  final String? selectedBrokerID;

  // input
  final String name;
  final String topic;
  final List<Attribute> attributes;

  // status
  final EditDeviceStatus status;
  final String? error;

  // initial
  final Device? initialDevice;

  @override
  List<Object?> get props => [
        id,
        parentGroupID,
        brokers,
        initialAttributes,
        attributes,
        name,
        topic,
        selectedBrokerID,
        initialDevice,
        status,
        error
      ];

  EditDeviceState copyWith({
    String? id,
    String? parentGroupID,
    List<Broker>? brokers,
    List<Attribute>? initialAttributes,
    List<Attribute>? attributes,
    String? name,
    String? topic,
    String? selectedBrokerID,
    String? tempAttributeName,
    String? tempAttributeJsonPath,
    EditDeviceStatus? status,
    Device? initialDevice,
    String? Function()? error,
  }) {
    return EditDeviceState(
      id: id ?? this.id,
      parentGroupID: parentGroupID ?? this.parentGroupID,
      initialAttributes: initialAttributes ?? this.initialAttributes,
      attributes: attributes ?? this.attributes,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      selectedBrokerID: selectedBrokerID ?? this.selectedBrokerID,
      brokers: brokers ?? this.brokers,
      status: status ?? this.status,
      initialDevice: initialDevice ?? this.initialDevice,
      error: error != null ? error() : this.error,
    );
  }
}

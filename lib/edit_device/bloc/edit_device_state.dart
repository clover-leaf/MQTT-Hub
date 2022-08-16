part of 'edit_device_bloc.dart';

class EditDeviceState extends Equatable {
  const EditDeviceState({
    required this.id,
    required this.path,
    required this.rootProject,
    required this.parentGroup,
    required this.initAttributes,
    required this.selectedAttributes,
    this.deviceName = const DeviceName.pure(),
    this.topicName = const TopicName.pure(),
    this.brokers = const [],
    this.selectedBrokerID,
    this.tempAttributeName = '',
    this.tempAttributeJsonPath = '',
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initDevice,
    this.error,
  });

  final FieldId id;
  final String path;
  final Project rootProject;
  final Group parentGroup;
  final List<Attribute> initAttributes;

  final DeviceName deviceName;
  final TopicName topicName;
  final FieldId? selectedBrokerID;
  final List<Attribute> selectedAttributes;

  final String tempAttributeName;
  final String tempAttributeJsonPath;

  final List<Broker> brokers;

  final FormzStatus status;
  final Device? initDevice;
  final bool valid;
  final String? error;

  List<Broker> get showedBrokers =>
      brokers.where((br) => br.projectID == rootProject.id).toList();

  Broker? get selectedBroker {
    final broker = brokers.where((br) => br.id == selectedBrokerID).toList();
    if (broker.length == 1) return broker.first;
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        path,
        rootProject,
        parentGroup,
        initAttributes,
        deviceName,
        topicName,
        selectedBrokerID,
        selectedAttributes,
        tempAttributeName,
        tempAttributeJsonPath,
        brokers,
        initDevice,
        status,
        valid,
        error
      ];

  EditDeviceState copyWith({
    FieldId? id,
    String? path,
    Project? rootProject,
    Group? parentGroup,
    List<Attribute>? initAttributes,
    List<Attribute>? selectedAttributes,
    DeviceName? deviceName,
    TopicName? topicName,
    FieldId? selectedBrokerID,
    String? tempAttributeName,
    String? tempAttributeJsonPath,
    List<Broker>? brokers,
    FormzStatus? status,
    bool? valid,
    Device? initDevice,
    String? error,
  }) {
    return EditDeviceState(
      id: id ?? this.id,
      path: path ?? this.path,
      rootProject: rootProject ?? this.rootProject,
      parentGroup: parentGroup ?? this.parentGroup,
      initAttributes: initAttributes ?? this.initAttributes,
      deviceName: deviceName ?? this.deviceName,
      topicName: topicName ?? this.topicName,
      selectedBrokerID: selectedBrokerID ?? this.selectedBrokerID,
      selectedAttributes: selectedAttributes ?? this.selectedAttributes,
      brokers: brokers ?? this.brokers,
      tempAttributeName: tempAttributeName ?? this.tempAttributeName,
      tempAttributeJsonPath:
          tempAttributeJsonPath ?? this.tempAttributeJsonPath,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initDevice: initDevice ?? this.initDevice,
      error: error ?? this.error,
    );
  }
}

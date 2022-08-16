part of 'edit_device_bloc.dart';

class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditDeviceEvent {
  const EditSubmitted({
    required this.deviceName,
    required this.topicName,
    required this.selectedBrokerID,
  });

  final String deviceName;
  final String topicName;
  final FieldId? selectedBrokerID;

  @override
  List<Object?> get props => [deviceName, topicName, selectedBrokerID];
}

class EditDeviceNameChanged extends EditDeviceEvent {
  const EditDeviceNameChanged(this.deviceName);

  final String deviceName;

  @override
  List<Object> get props => [deviceName];
}

class EditTopicNameChanged extends EditDeviceEvent {
  const EditTopicNameChanged(this.topicName);

  final String topicName;

  @override
  List<Object> get props => [topicName];
}

class EditSelectedBrokerIDChanged extends EditDeviceEvent {
  const EditSelectedBrokerIDChanged(this.selectedBrokerID);

  final FieldId? selectedBrokerID;

  @override
  List<Object?> get props => [selectedBrokerID];
}

class EditTempAttributeNameChanged extends EditDeviceEvent {
  const EditTempAttributeNameChanged(this.tempAttributeName);

  final String? tempAttributeName;

  @override
  List<Object?> get props => [tempAttributeName];
}

class EditTempAttributeJsonPathChanged extends EditDeviceEvent {
  const EditTempAttributeJsonPathChanged(this.tempAttributeJsonPath);

  final String? tempAttributeJsonPath;

  @override
  List<Object?> get props => [tempAttributeJsonPath];
}

class EditTempAttributeSaved extends EditDeviceEvent {
  const EditTempAttributeSaved();
}

class BrokerSubscriptionRequested extends EditDeviceEvent {
  const BrokerSubscriptionRequested();
}

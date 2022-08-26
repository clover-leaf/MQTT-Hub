part of 'edit_device_bloc.dart';

class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditDeviceEvent {
  const Submitted();
}

class NameChanged extends EditDeviceEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class TopicChanged extends EditDeviceEvent {
  const TopicChanged(this.topic);

  final String topic;

  @override
  List<Object> get props => [topic];
}

class SelectedBrokerIDChanged extends EditDeviceEvent {
  const SelectedBrokerIDChanged(this.selectedBrokerID);

  final FieldId selectedBrokerID;

  @override
  List<Object?> get props => [selectedBrokerID];
}

class AttributesChanged extends EditDeviceEvent {
  const AttributesChanged(this.attributes);

  final List<Attribute> attributes;

  @override
  List<Object?> get props => [attributes];
}

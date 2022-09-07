part of 'edit_device_bloc.dart';

class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditDeviceEvent {
  const Submitted();
}

class IsEditChanged extends EditDeviceEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
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

class DescriptionChanged extends EditDeviceEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class QosChanged extends EditDeviceEvent {
  const QosChanged(this.qos);

  final int qos;

  @override
  List<Object> get props => [qos];
}

class SelectedBrokerIDChanged extends EditDeviceEvent {
  const SelectedBrokerIDChanged(this.selectedBrokerID);

  final String selectedBrokerID;

  @override
  List<Object?> get props => [selectedBrokerID];
}

class SelectedDeviceTypeIDChanged extends EditDeviceEvent {
  const SelectedDeviceTypeIDChanged(this.selectedDeviceTypeID);

  final String? Function() selectedDeviceTypeID;

  @override
  List<Object?> get props => [selectedDeviceTypeID];
}

class AttributesChanged extends EditDeviceEvent {
  const AttributesChanged(this.attributes);

  final List<Attribute> attributes;

  @override
  List<Object?> get props => [attributes];
}

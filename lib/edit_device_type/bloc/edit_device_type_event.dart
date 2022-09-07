part of 'edit_device_type_bloc.dart';

class EditDeviceTypeEvent extends Equatable {
  const EditDeviceTypeEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditDeviceTypeEvent {
  const Submitted();
}

class IsEditChanged extends EditDeviceTypeEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}

class NameChanged extends EditDeviceTypeEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends EditDeviceTypeEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class AttributesChanged extends EditDeviceTypeEvent {
  const AttributesChanged(this.attributes);

  final List<Attribute> attributes;

  @override
  List<Object?> get props => [attributes];
}

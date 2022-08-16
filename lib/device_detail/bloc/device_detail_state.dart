part of 'device_detail_bloc.dart';

class DeviceDetailState extends Equatable {
  const DeviceDetailState({
    required this.path,
    required this.device,
    this.attributes = const [],
  });

  final String path;
  final Device device;
  final List<Attribute> attributes;

  List<Attribute> get showedAttributes =>
      attributes.where((attr) => attr.deviceID == device.id).toList();

  @override
  List<Object> get props => [path, device, attributes];

  DeviceDetailState copyWith({
    String? path,
    Device? device,
    List<Attribute>? attributes,
  }) {
    return DeviceDetailState(
      path: path ?? this.path,
      device: device ?? this.device,
      attributes: attributes ?? this.attributes,
    );
  }
}

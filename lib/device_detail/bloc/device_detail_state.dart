part of 'device_detail_bloc.dart';

class DeviceDetailState extends Equatable {
  const DeviceDetailState({
    required this.device,
    required this.parentGroup,
  });

  final Device device;
  final Group parentGroup;

  @override
  List<Object> get props => [device, parentGroup];

  DeviceDetailState copyWith({
    Device? device,
    Group? parentGroup,
  }) {
    return DeviceDetailState(
      device: device ?? this.device,
      parentGroup: parentGroup ?? this.parentGroup,
    );
  }
}

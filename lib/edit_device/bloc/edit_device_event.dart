part of 'edit_device_bloc.dart';

class EditDeviceEvent extends Equatable {
  const EditDeviceEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditDeviceEvent {
  const EditSubmitted({
    required this.deviceName,
  });

  final String deviceName;

  @override
  List<Object> get props => [deviceName];
}

class EditDeviceNameChanged extends EditDeviceEvent {
  const EditDeviceNameChanged(this.deviceName);

  final String deviceName;

  @override
  List<Object> get props => [deviceName];
}

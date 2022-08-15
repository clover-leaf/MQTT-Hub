part of 'edit_device_bloc.dart';

class EditDeviceState extends Equatable {
  const EditDeviceState({
    required this.parentGroup,
    this.deviceName = const DeviceName.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initDevice,
    this.error,
  });

  final Group parentGroup;
  final DeviceName deviceName;
  final FormzStatus status;
  final Device? initDevice;
  final bool valid;
  final String? error;

  @override
  List<Object?> get props =>
      [parentGroup, deviceName, initDevice, status, valid, error];

  EditDeviceState copyWith({
    Group? parentGroup,
    DeviceName? deviceName,
    FormzStatus? status,
    bool? valid,
    Device? initDevice,
    String? error,
  }) {
    return EditDeviceState(
      parentGroup: parentGroup ?? this.parentGroup,
      deviceName: deviceName ?? this.deviceName,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initDevice: initDevice ?? this.initDevice,
      error: error ?? this.error,
    );
  }
}

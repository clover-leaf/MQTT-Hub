import 'package:formz/formz.dart';

/// Device Name Form Input Validation Error.
enum DeviceNameValidationError {
  /// Device Name is invalid (generic validation error).
  invalid
}

/// {@template Device_name}
/// Reusable Device name form input.
/// {@endtemplate}
class DeviceName extends FormzInput<String, DeviceNameValidationError> {
  /// {@macro Device_name}
  const DeviceName.pure() : super.pure('');

  /// {@macro Device_name}
  const DeviceName.dirty([super.value = '']) : super.dirty();

  @override
  DeviceNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : DeviceNameValidationError.invalid;
  }
}

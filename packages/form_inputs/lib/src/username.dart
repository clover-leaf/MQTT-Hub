import 'package:formz/formz.dart';

/// Username Form Input Validation Error.
enum UsernameValidationError {
  /// Username is invalid (generic validation error).
  invalid
}

/// {@template Group_name}
/// Reusable Username form input.
/// {@endtemplate}
class Username extends FormzInput<String, UsernameValidationError> {
  /// {@macro Group_name}
  const Username.pure() : super.pure('');

  /// {@macro Group_name}
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    return value.isNotEmpty ? null : UsernameValidationError.invalid;
  }
}

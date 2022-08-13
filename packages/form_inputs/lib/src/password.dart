import 'package:formz/formz.dart';

/// Password Form Input Validation Error.
enum PasswordValidationError {
  /// Password is invalid (generic validation error).
  invalid
}

/// {@template Password}
/// Reusable Password form input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro Password}
  const Password.pure() : super.pure('');

  /// {@macro Password}
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return value.isNotEmpty ? null : PasswordValidationError.invalid;
  }
}
